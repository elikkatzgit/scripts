ssh-keygen ; cat ~/.ssh/id_rsa.pub | ssh iu@10.128.122.33 "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"



ssh-keygen ; cat ~/.ssh/id_rsa.pub | ssh omni@beta1 "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"