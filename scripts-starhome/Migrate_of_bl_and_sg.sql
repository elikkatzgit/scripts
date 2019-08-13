CREATE OR REPLACE procedure UKR_MTSQQ_SPARX.Migrate_of_BL_and_SG as 

 
CURSOR merge_population IS
SELECT * FROM (
        SELECT KEY1, SOURCE, TS_END_DATE, CODE_OPTION, TS_LAST_MODIFIED, NULL SFI_TABLE_COLUMN, SH_GROUP
          FROM SFI_CUSTOMER_OPTIONS
         WHERE SH_GROUP = '1800'
    UNION ALL
        SELECT KEY1, SOURCE, TS_END_DATE, CODE_OPTION, TS_LAST_MODIFIED, SFI_TABLE_COLUMN, SH_GROUP
          FROM SFI_CUSTOMER_OPTIONS, GA_SUBS_ATTR_CRITER_VALS
         WHERE SH_GROUP = '1801'
           AND CRITERION_VALUE = CODE_OPTION
           AND SFI_TABLE_COLUMN IS NOT NULL
)
ORDER BY KEY1, TS_LAST_MODIFIED;
                                     

CURSOR attribute_values IS
SELECT acv.entry_id FROM ga_subs_attr_criteria ac, ga_subs_attr_criter_vals acv
        WHERE ac.criterion_attribute_id = acv.criterion_attribute_id
          AND ac.functional_attr_type_id = 1801
        ORDER BY ac.criterion_attribute_id, acv.entry_id;

TYPE aat_key1 IS TABLE OF SFI_CUSTOMER_OPTIONS.KEY1%TYPE INDEX BY PLS_INTEGER;
TYPE aat_code_option IS TABLE OF SFI_CUSTOMER_OPTIONS.CODE_OPTION%TYPE INDEX BY PLS_INTEGER;
TYPE aat_end_date IS TABLE OF SFI_CUSTOMER_OPTIONS.TS_END_DATE%TYPE INDEX BY PLS_INTEGER;
TYPE aat_source IS TABLE OF SFI_CUSTOMER_OPTIONS.SOURCE%TYPE INDEX BY PLS_INTEGER;
TYPE aat_last_modified IS TABLE OF SFI_CUSTOMER_OPTIONS.TS_LAST_MODIFIED%TYPE INDEX BY PLS_INTEGER;
TYPE aat_sh_group IS TABLE OF SFI_CUSTOMER_OPTIONS.SH_GROUP%TYPE INDEX BY PLS_INTEGER;
TYPE aat_sfi_table_column IS TABLE OF GA_SUBS_ATTR_CRITER_VALS.SFI_TABLE_COLUMN%TYPE INDEX BY PLS_INTEGER;

v_black_sparx                VARCHAR2(8 CHAR):='';
v_black_sparx_src            VARCHAR2(12 CHAR):='';
v_black_sparx_out            NUMBER(1):=null;

v_black_info                 VARCHAR2(8 CHAR):='';
v_black_info_src             VARCHAR2(12 CHAR):='';
v_black_info_out             NUMBER(1):=null;

v_black_market               VARCHAR2(8 CHAR):='';
v_black_market_src           VARCHAR2(12 CHAR):='';
v_black_market_out           NUMBER(1):=null;

v_black_tariff               VARCHAR2(8 CHAR):='';
v_black_tariff_src           VARCHAR2(12 CHAR):='';
v_black_tariff_out           NUMBER(1):=null;

v_black_megaevent            VARCHAR2(8 CHAR):='';
v_black_megaevent_src        VARCHAR2(12 CHAR):='';
v_black_megaevent_out        NUMBER(1):=null;

v_black_externaltrigger      VARCHAR2(8 CHAR):='';
v_black_externaltrigger_src  VARCHAR2(12 CHAR):='';
v_black_externaltrigger_out  NUMBER(1):=null;

v_black_broadcast            VARCHAR2(8 CHAR):='';
v_black_broadcast_src        VARCHAR2(12 CHAR):='';
v_black_broadcast_out        NUMBER(1):=null;

v_last_modified              DATE;

v_sg1                       VARCHAR2(30 CHAR):='';
v_sg2                       VARCHAR2(30 CHAR):='';
v_sg3                       VARCHAR2(30 CHAR):='';
v_sg4                       VARCHAR2(30 CHAR):='';
v_sg5                       VARCHAR2(30 CHAR):='';
v_sg6                       VARCHAR2(30 CHAR):='';
v_sg7                       VARCHAR2(30 CHAR):='';
v_sg8                       VARCHAR2(30 CHAR):='';
v_sg9                       VARCHAR2(30 CHAR):='';
v_sg10                       VARCHAR2(30 CHAR):='';
v_sg11                       VARCHAR2(30 CHAR):='';
v_sg12                       VARCHAR2(30 CHAR):='';
v_sg13                       VARCHAR2(30 CHAR):='';
v_sg14                       VARCHAR2(30 CHAR):='';
v_sg15                       VARCHAR2(30 CHAR):='';
v_sg16                       VARCHAR2(30 CHAR):='';
v_sg17                       VARCHAR2(30 CHAR):='';
v_sg18                       VARCHAR2(30 CHAR):='';
v_sg19                       VARCHAR2(30 CHAR):='';
v_sg20                       VARCHAR2(30 CHAR):='';

aat_key1s                aat_key1;
aat_code_options         aat_code_option;
aat_end_dates            aat_end_date;
aat_sources              aat_source;
aat_last_modifieds       aat_last_modified;
aat_sh_groups            aat_sh_group;
aat_sfi_table_columns    aat_sfi_table_column;

v_counter number(12);
v_total_counter number(12);
v_bulk_counter number(12):=0;
temp_key varchar2(30 char);
last_key varchar2(30 char);
v_out VARCHAR2(1 CHAR):='';--NUMBER(1):=0;
v_black VARCHAR2(8 CHAR):='';
vNum number(10):= 1 ;



BEGIN

        SELECT COUNT( DISTINCT key1) INTO v_counter FROM SFI_CUSTOMER_OPTIONS 
        WHERE SH_GROUP = '1800';
        sga_pkg.WRITE_SGA_W_LOG('Migrate_of_BL_and_SG', 'Found : ' || v_counter ||  ' distinct subscribers with blacklist in the SFI_CUSTOMER_OPTIONS.');


        SELECT COUNT( DISTINCT key1) INTO v_counter FROM SFI_CUSTOMER_OPTIONS 
        WHERE SH_GROUP = '1801';
        sga_pkg.WRITE_SGA_W_LOG('Migrate_of_BL_and_SG',  'Found : ' || v_counter  ||  ' distinct subscribers with special groups in the SFI_CUSTOMER_OPTIONS.');

        SELECT COUNT( DISTINCT key1) INTO v_counter FROM SFI_CUSTOMER_OPTIONS 
        WHERE SH_GROUP = '1801' 
        OR  SH_GROUP = '1800';
        sga_pkg.WRITE_SGA_W_LOG('Migrate_of_BL_and_SG', 'Total distinct subscribers to migrate to the SFI_CUSTOMER_PROFILE is :' || v_counter);

        v_counter:=0;
        v_total_counter:=0;

        FOR i in attribute_values LOOP
        UPDATE GA_SUBS_ATTR_CRITER_VALS SET SFI_TABLE_COLUMN = 'SG' || vNum
                WHERE entry_id = i.entry_id;
        vNum := vNum+1;

        END LOOP;

        COMMIT;
        sga_pkg.WRITE_SGA_W_LOG('Migrate_of_BL_and_SG',  'update the SFI_TABLE_COLUMN  with ' || vNum ||  ' special groups');





    OPEN merge_population;

    FETCH merge_population BULK COLLECT
    INTO aat_key1s, aat_sources, aat_end_dates, aat_code_options, aat_last_modifieds, aat_sfi_table_columns, aat_sh_groups;

     FOR i IN 1 .. aat_key1s.COUNT 
     LOOP 
     
    
        IF (temp_key is null) THEN
            temp_key := aat_key1s(i);
        ELSE 
            IF (temp_key != aat_key1s(i)) THEN 
            
            MERGE INTO SFI_CUSTOMER_PROFILE  tgt
            USING (SELECT temp_key as key1 FROM dual) src
               ON (src.key1 = tgt.key1)
            WHEN MATCHED THEN
                UPDATE SET
                        BLACK_SPARX = v_black_sparx,
                        BLACK_SPARX_SRC = v_black_sparx_src,
                                                BLACK_SPARX_OUT = v_black_sparx_out,
                        BLACK_INFO = v_black_info,
                        BLACK_INFO_SRC = v_black_info_src,
                        BLACK_INFO_OUT = v_black_info_out,
                                                BLACK_MARKET = v_black_market,
                        BLACK_MARKET_SRC = v_black_market_src,
                        BLACK_MARKET_OUT = v_black_market_out,
                                                BLACK_TARIFF = v_black_tariff,
                        BLACK_TARIFF_SRC = v_black_tariff_src,
                        BLACK_TARIFF_OUT = v_black_tariff_out,
                                                BLACK_MEGAEVENT = v_black_megaevent,
                        BLACK_MEGAEVENT_SRC = v_black_megaevent_src,
                        BLACK_MEGAEVENT_OUT = v_black_megaevent_out,
                                                BLACK_EXTERNALTRIGGER = v_black_externaltrigger,
                        BLACK_EXTERNALTRIGGER_SRC = v_black_externaltrigger_src,
                        BLACK_EXTERNALTRIGGER_OUT = v_black_externaltrigger_out,
                                                BLACK_BROADCAST = v_black_broadcast,
                        BLACK_BROADCAST_SRC = v_black_broadcast_src,
                        BLACK_BROADCAST_OUT = v_black_broadcast_out,
                                                BLACK_TS_LAST_MODIFIED = v_last_modified,
                        SG1=v_sg1, SG2=v_sg2, SG3=v_sg3, SG4=v_sg4, SG5=v_sg5, SG6=v_sg6,
                        SG7=v_sg7, SG8=v_sg8, SG9=v_sg9, SG10=v_sg10, SG11=v_sg11, SG12=v_sg12,
                        SG13=v_sg13, SG14=v_sg14, SG15=v_sg15, SG16=v_sg16, SG17=v_sg17, 
                        SG18=v_sg18, SG19=v_sg19, SG20=v_sg20
            WHEN NOT MATCHED THEN
                INSERT (KEY1, BLACK_SPARX, BLACK_SPARX_SRC, BLACK_SPARX_OUT, BLACK_INFO, BLACK_INFO_SRC, BLACK_INFO_OUT, BLACK_MARKET, BLACK_MARKET_SRC, BLACK_MARKET_OUT,
                        BLACK_TARIFF, BLACK_TARIFF_SRC, BLACK_TARIFF_OUT, BLACK_MEGAEVENT, BLACK_MEGAEVENT_SRC, BLACK_MEGAEVENT_OUT, BLACK_EXTERNALTRIGGER, 
                        BLACK_EXTERNALTRIGGER_SRC, BLACK_EXTERNALTRIGGER_OUT, BLACK_BROADCAST, BLACK_BROADCAST_SRC, BLACK_BROADCAST_OUT, BLACK_TS_LAST_MODIFIED,
                        SG1, SG2, SG3, SG4, SG5, SG6, SG7, SG8, SG9, SG10, SG11, SG12, SG13, SG14, SG15, 
                        SG16, SG17, SG18, SG19, SG20)
                VALUES
                        (temp_key, v_black_sparx, v_black_sparx_src, v_black_sparx_out, v_black_info, v_black_info_src, v_black_info_out, v_black_market, 
                        v_black_market_src, v_black_market_out, v_black_tariff, v_black_tariff_src, v_black_tariff_out, v_black_megaevent, v_black_megaevent_src, v_black_megaevent_out,
                        v_black_externaltrigger, v_black_externaltrigger_src, v_black_externaltrigger_out, v_black_broadcast, v_black_broadcast_src, v_black_broadcast_out, 
                        v_last_modified, v_sg1, v_sg2, v_sg3, v_sg4, v_sg5, v_sg6, v_sg7, v_sg8, v_sg9, v_sg10, v_sg11,
                        v_sg12, v_sg13, v_sg14, v_sg15, v_sg16, v_sg17, v_sg18, v_sg19, v_sg20);

                v_counter := v_counter + 1;

                temp_key := aat_key1s(i);
                v_black_sparx               :='';
                v_black_sparx_src           :='';
                                v_black_sparx_out                       :=null;
                v_black_info                :='';
                v_black_info_src            :='';
                                v_black_info_out                        :=null;
                v_black_market              :='';
                v_black_market_src          :='';
                                v_black_market_out                      :=null;
                v_black_tariff              :='';
                v_black_tariff_src          :='';
                                v_black_tariff_out                      :=null;
                v_black_megaevent           :='';
                v_black_megaevent_src       :='';
                                v_black_megaevent_out       :=null;
                v_black_externaltrigger     :='';
                v_black_externaltrigger_src :='';
                                v_black_externaltrigger_out :=null; 
                v_black_broadcast           :='';
                v_black_broadcast_src       :='';
                                v_black_broadcast_out           :=null;
                v_sg1                       :='';
                v_sg2                       :='';
                v_sg3                       :='';
                v_sg4                       :='';
                v_sg5                       :='';
                v_sg6                       :='';
                v_sg7                       :='';
                v_sg8                       :='';
                v_sg9                       :='';
                v_sg10                      :='';
                v_sg11                      :='';
                v_sg12                      :='';
                v_sg13                      :='';
                v_sg14                      :='';
                v_sg15                      :='';
                v_sg16                      :='';
                v_sg17                      :='';
                v_sg18                      :='';
                v_sg19                      :='';
                v_sg20                      :='';            
                    
                IF v_counter >= 50000 THEN
                    v_total_counter := v_total_counter + v_counter;
                    COMMIT;                 
                    v_bulk_counter := v_bulk_counter + 1;                   
                                        sga_pkg.WRITE_SGA_W_LOG('Migrate_of_BL_and_SG', 'Records processed till now: ' || v_total_counter || 
                                        ', Batch: ' || v_bulk_counter);
                    v_counter := 0;
                END IF;
                
            END IF;
            
        END IF;

        IF aat_sh_groups(i) = '1800' THEN
                IF aat_end_dates(i) is not null THEN
        v_out := 0;
      else
        v_out:= 1;
              
      end if;

                IF v_out = 1 THEN

                v_black:= TO_CHAR(aat_last_modifieds(i),'YYYYMMDD');
                else
                v_black:=aat_end_dates(i);
                end if;

                if aat_sources(i) is null then
                v_out:=null;
                end if;

            CASE aat_code_options(i)
                when '_SPARX' then
                        v_black_sparx                   := v_black;
                        v_black_sparx_src               := to_char(aat_sources(i)); 
                                                v_black_sparx_out                               := v_out;
                when '_INFO' then
                        v_black_info                    := v_black;
                        v_black_info_src                := to_char(aat_sources(i)); 
                                                v_black_info_out                                := v_out;
                when '_MARKET' then
                        v_black_market                  := v_black;
                        v_black_market_src              := to_char(aat_sources(i)); 
                                                v_black_market_out                              := v_out;
                when '_TARIFF' then
                        v_black_tariff                  := v_black;
                        v_black_tariff_src              := to_char(aat_sources(i));
                                                v_black_tariff_out                              := v_out;
                when '_MEGAEVENT' then
                        v_black_megaevent               := v_black;
                        v_black_megaevent_src           := to_char(aat_sources(i));
                                                v_black_megaevent_out                   := v_out;
                when '_EXTERNALTRIGGER' then  
                        v_black_externaltrigger         := v_black;
                        v_black_externaltrigger_src     := to_char(aat_sources(i));
                                                v_black_externaltrigger_out             := v_out;
                when '_BROADCAST' then  
                        v_black_broadcast               := v_black;
                        v_black_broadcast_src           := to_char(aat_sources(i));
                                                v_black_broadcast_out                   := v_out;
            END CASE;
            
            v_last_modified := aat_last_modifieds(i);                    
        ELSE
        
            IF aat_sh_groups(i) = '1801' THEN
                CASE aat_sfi_table_columns(i)
                    when 'SG1' then
                            v_sg1 := to_char(aat_code_options(i));
                    when 'SG2' then
                            v_sg2 := to_char(aat_code_options(i));         
                    when 'SG3' then
                            v_sg3 := to_char(aat_code_options(i));      
                    when 'SG4' then
                            v_sg4 := to_char(aat_code_options(i));        
                    when 'SG5' then
                            v_sg5 := to_char(aat_code_options(i));      
                    when 'SG6' then  
                            v_sg6 := to_char(aat_code_options(i)); 
                    when 'SG7' then  
                            v_sg7 := to_char(aat_code_options(i));
                    when 'SG8' then
                            v_sg8 := to_char(aat_code_options(i));
                    when 'SG9' then
                            v_sg9 := to_char(aat_code_options(i));         
                    when 'SG10' then
                            v_sg10 := to_char(aat_code_options(i));      
                    when 'SG11' then
                            v_sg11 := to_char(aat_code_options(i));        
                    when 'SG12' then
                            v_sg12 := to_char(aat_code_options(i));      
                    when 'SG13' then  
                            v_sg13 := to_char(aat_code_options(i)); 
                    when 'SG14' then  
                            v_sg14 := to_char(aat_code_options(i));
                    when 'SG15' then
                            v_sg15 := to_char(aat_code_options(i));
                    when 'SG16' then
                            v_sg16 := to_char(aat_code_options(i));         
                    when 'SG17' then
                            v_sg17 := to_char(aat_code_options(i));      
                    when 'SG18' then
                            v_sg18 := to_char(aat_code_options(i));        
                    when 'SG19' then
                            v_sg19 := to_char(aat_code_options(i));      
                    when 'SG20' then  
                            v_sg20 := to_char(aat_code_options(i));                      
                END CASE;
                 
            END IF; 
                
        END IF;
                    last_key:=aat_key1s(i);        


    END LOOP;
    
    IF (last_key is not null) THEN
            MERGE INTO SFI_CUSTOMER_PROFILE  tgt
            USING (SELECT temp_key as key1 FROM dual) src
               ON (src.key1 = tgt.key1)
            WHEN MATCHED THEN
                UPDATE SET
                        BLACK_SPARX = v_black_sparx,
                        BLACK_SPARX_SRC = v_black_sparx_src,
                                                BLACK_SPARX_OUT = v_black_sparx_out,
                        BLACK_INFO = v_black_info,
                        BLACK_INFO_SRC = v_black_info_src,
                        BLACK_INFO_OUT = v_black_info_out,
                                                BLACK_MARKET = v_black_market,
                        BLACK_MARKET_SRC = v_black_market_src,
                        BLACK_MARKET_OUT = v_black_market_out,
                                                BLACK_TARIFF = v_black_tariff,
                        BLACK_TARIFF_SRC = v_black_tariff_src,
                        BLACK_TARIFF_OUT = v_black_tariff_out,
                                                BLACK_MEGAEVENT = v_black_megaevent,
                        BLACK_MEGAEVENT_SRC = v_black_megaevent_src,
                        BLACK_MEGAEVENT_OUT = v_black_megaevent_out,
                                                BLACK_EXTERNALTRIGGER = v_black_externaltrigger,
                        BLACK_EXTERNALTRIGGER_SRC = v_black_externaltrigger_src,
                        BLACK_EXTERNALTRIGGER_OUT = v_black_externaltrigger_out,
                                                BLACK_BROADCAST = v_black_broadcast,
                        BLACK_BROADCAST_SRC = v_black_broadcast_src,
                        BLACK_BROADCAST_OUT = v_black_broadcast_out,
                                                BLACK_TS_LAST_MODIFIED = v_last_modified,
                        SG1=v_sg1, SG2=v_sg2, SG3=v_sg3, SG4=v_sg4, SG5=v_sg5, SG6=v_sg6,
                        SG7=v_sg7, SG8=v_sg8, SG9=v_sg9, SG10=v_sg10, SG11=v_sg11, SG12=v_sg12,
                        SG13=v_sg13, SG14=v_sg14, SG15=v_sg15, SG16=v_sg16, SG17=v_sg17, 
                        SG18=v_sg18, SG19=v_sg19, SG20=v_sg20
            WHEN NOT MATCHED THEN
                INSERT (KEY1, BLACK_SPARX, BLACK_SPARX_SRC, BLACK_SPARX_OUT, BLACK_INFO, BLACK_INFO_SRC, BLACK_INFO_OUT, BLACK_MARKET, BLACK_MARKET_SRC, BLACK_MARKET_OUT,
                        BLACK_TARIFF, BLACK_TARIFF_SRC, BLACK_TARIFF_OUT, BLACK_MEGAEVENT, BLACK_MEGAEVENT_SRC, BLACK_MEGAEVENT_OUT, BLACK_EXTERNALTRIGGER, 
                        BLACK_EXTERNALTRIGGER_SRC, BLACK_EXTERNALTRIGGER_OUT, BLACK_BROADCAST, BLACK_BROADCAST_SRC, BLACK_BROADCAST_OUT, BLACK_TS_LAST_MODIFIED,
                        SG1, SG2, SG3, SG4, SG5, SG6, SG7, SG8, SG9, SG10, SG11, SG12, SG13, SG14, SG15, 
                        SG16, SG17, SG18, SG19, SG20)
                VALUES
                        (temp_key, v_black_sparx, v_black_sparx_src, v_black_sparx_out, v_black_info, v_black_info_src, v_black_info_out, v_black_market, 
                        v_black_market_src, v_black_market_out, v_black_tariff, v_black_tariff_src, v_black_tariff_out, v_black_megaevent, v_black_megaevent_src, v_black_megaevent_out,
                        v_black_externaltrigger, v_black_externaltrigger_src, v_black_externaltrigger_out, v_black_broadcast, v_black_broadcast_src, v_black_broadcast_out, 
                        v_last_modified, v_sg1, v_sg2, v_sg3, v_sg4, v_sg5, v_sg6, v_sg7, v_sg8, v_sg9, v_sg10, v_sg11,
                        v_sg12, v_sg13, v_sg14, v_sg15, v_sg16, v_sg17, v_sg18, v_sg19, v_sg20);
                        
        COMMIT;
        v_counter := v_counter+1;
    END IF;
    
    v_total_counter := v_total_counter + v_counter;
    v_bulk_counter := v_bulk_counter + 1;

    sga_pkg.WRITE_SGA_W_LOG('Migrate_of_BL_and_SG',  'Total records: ' || v_total_counter || ', Batch: ' || v_bulk_counter);

    CLOSE merge_population;
exception
when others then
rollback;
sga_pkg.WRITE_SGA_W_LOG('Migrate_of_BL_and_SG',  'Error: ' || SQLERRM);

END Migrate_of_BL_and_SG;
/
