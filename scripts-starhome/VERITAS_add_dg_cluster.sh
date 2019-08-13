#!/bin/bash

if [ $# -ne 2 ]; then
        echo "Usage:"
        echo "  ./add_dg_cluster.sh <sg_name> <mount_point>"
        exit 1
fi

#Input parameters: igate's service group "xxx-yyy-zzz_ig2_1_sg"
sg_name=`echo $1 | sed 's/_sg//g'`
MNT_POINT=$2

# get the next volume with centralize -d (SthDg? ShVol? /dev/vx/dsk/SthDg?/ShVol?)
centr=`/usr/local/etc/starhome/sbin/centralize -d`
#echo "$centr"

if [[ $centr =~ .*ERR.* ]]; then
        echo "ERROR!"
        exit 1
fi

sg_pkg_dg=`echo $centr | cut -d " " -f 1`
sg_pkg_vol=`echo $centr | cut -d " " -f 2`
sg_pkg_device=`echo $centr | cut -d " " -f 3`

echo "START"

# open configuration
echo "  --- Open Configuration"
haconf -makerw

# Add $sg_pkg_dg DiskGroup
echo "  --- Adding disk group resource: ${sg_name}_dg"
hares -add ${sg_name}_dg DiskGroup ${sg_name}_sg

# Add attribute $sg_pkg_dg to DiskGroup resource
echo "  --- Setting Disk Group as ${sg_pkg_dg}"
hares -modify ${sg_name}_dg DiskGroup ${sg_pkg_dg}

# Add $VOL_NAME Volume
echo "  --- Adding volume resource: ${sg_name}_vol"
hares -add ${sg_name}_vol Volume ${sg_name}_sg

# Add attribute DiskGroup to $VOL_NAME Volume resource
echo "  --- Attaching volume resource to disk group"
hares -modify ${sg_name}_vol DiskGroup ${sg_pkg_dg}

# Add attribute Volume to $VOL_NAME Volume resource
echo "  --- Setting volume as ${sg_pkg_vol}"
hares -modify ${sg_name}_vol Volume ${sg_pkg_vol}

# Add $MNT_NAME Mount resource
echo "  --- Adding mount resource: ${sg_name}_mnt"
hares -add ${sg_name}_mnt Mount ${sg_name}_sg

# Add attribute MountPoint to Mount resource
echo "  --- Setting mount point as ${MNT_POINT}"
hares -modify ${sg_name}_mnt MountPoint ${MNT_POINT}

# Add attribute BlockDevice to Mount resource
echo "  --- Setting BlockDevice as ${sg_pkg_device}"
hares -modify ${sg_name}_mnt BlockDevice ${sg_pkg_device}

# Add attribute FSType to Mount resource
echo "  --- Setting FSType as vxfs"
hares -modify ${sg_name}_mnt FSType vxfs

# Add attribute MountOpt to Mount resource
echo "  --- Setting mount options as rw"
hares -modify ${sg_name}_mnt MountOpt rw

# Add attribute FsckOpt to Mount resource
echo "  --- Setting FS check options as -y"
hares -modify ${sg_name}_mnt FsckOpt %-y

# Link vol and mnt res to dg
echo "  --- Creating resources dependencies"
hares -link ${sg_name}_vol ${sg_name}_dg
hares -link ${sg_name}_mnt ${sg_name}_vol
hares -link ${sg_name}_ap ${sg_name}_mnt

#Enable all resources
echo "  --- Enabling all resources"
hagrp -enableresources ${sg_name}_sg

# close configuration
echo "  --- Closing configuration"
haconf -dump -makero

echo "Done!"
echo "-------------------------------------------------------------"
echo "!!! Don't forget to update vcs_profile for service group $1"
echo "-------------------------------------------------------------"
echo "sg_<igate_type>_dg=${sg_pkg_dg}"
echo "sg_<igate_type>_vol=${sg_pkg_vol}"
echo "sg_<igate_type>_device=${sg_pkg_device}"
echo "-------------------------------------------------------------"