PROCEDURE REPORT_BLACK_LIST IS

    CURSOR BLACK_SPARX_CUR IS
    select key1 from SFI_CUSTOMER_PROFILE where black_sparx is not null and black_sparx_out='1';
    
    CURSOR BLACK_INFO_CUR IS
    select key1 from SFI_CUSTOMER_PROFILE where black_info is not null and black_info_out='1';
    
    CURSOR BLACK_MARKET_CUR IS
    select key1 from SFI_CUSTOMER_PROFILE where black_market is not null and black_market_out='1';
     
    CURSOR BLACK_TARIFF_CUR IS
    select key1 from SFI_CUSTOMER_PROFILE where black_tariff is not null and black_tariff_out='1';     

    CURSOR BLACK_EXT_TRG_OUT_CUR IS
    select key1 from SFI_CUSTOMER_PROFILE where black_externaltrigger is not null and black_externaltrigger_out='1';       
    
    v_module_name     SGA_W_LOG.procedure_name%TYPE;  
    v_msg_text_header SGA_W_LOG.data%TYPE;
    v_msg_text        SGA_W_LOG.data%TYPE;
    
    --v_timestamp      VARCHAR2(100);
    v_file_handle    UTL_FILE.FILE_TYPE;    
    v_directory_name ALL_DIRECTORIES.directory_name%TYPE;   
    v_file_name      VARCHAR2(300); 
    v_file_suffix    VARCHAR2(4);
    
    C_BLACK_SPARX_FILE VARCHAR2(300)  := 'BLACK_SPARX';
    C_BLACK_INFO_FILE VARCHAR2(300)   := 'BLACK_INFO';    
    C_BLACK_MARKET_FILE VARCHAR2(300) := 'BLACK_MARKET';
    C_BLACK_TARIFF_FILE VARCHAR2(300) := 'BLACK_TARIFF';
    C_BLACK_EXT_TRG_OUT_FILE VARCHAR2(300) := 'BLACK_BLACK_EXT_TRG_OUT';       
    
    v_black_sparx_active   NUMBER;
    v_black_info_active    NUMBER;    
    v_black_market_active  NUMBER;
    v_black_tariff_active  NUMBER;
    v_black_ext_trg_out_active NUMBER;       

  BEGIN

    -----------------------------------
    -- Set for Active black lists
    -----------------------------------
    v_black_sparx_active   :=1;
    v_black_info_active    :=1;    
    v_black_market_active  :=1;
    v_black_tariff_active  :=1;
    v_black_ext_trg_out_active :=0;

    v_module_name := 'REPORT_BLACK_LIST';
    v_msg_text_header := '=================================================================';

    v_directory_name :=  'IG_EXP_DIR';
    v_file_suffix    := '.csv';
    
    v_msg_text := v_msg_text_header;
    WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    v_msg_text := 'Starting at: '||SYSDATE;
    WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    
    --v_timestamp := TO_CHAR(SYSDATE,'YYYYMMDD_hh24miss');
    
    -----------------------------------------
    -- Handle black_sparx
    -----------------------------------------  
    IF v_black_sparx_active = 1 THEN
      v_file_name := C_BLACK_SPARX_FILE||v_file_suffix;
      
      v_msg_text := 'Starting BLACK_SPARX at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      v_msg_text := 'Writing to Directory: '||v_directory_name||' File: '||v_file_name;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);    

      v_file_handle := UTL_FILE.FOPEN(v_directory_name, v_file_name, 'W');

      FOR black_list_rec IN black_sparx_cur LOOP
        UTL_FILE.PUT_LINE(v_file_handle, black_list_rec.key1);
      END LOOP;
      UTL_FILE.FCLOSE(v_file_handle);   
      
      v_msg_text := 'Finished BLACK_SPARX at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      
      v_msg_text := v_msg_text_header;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    END IF;        
    -----------------------------------------
    -- Handle black_info
    -----------------------------------------  
    IF v_black_info_active = 1 THEN
      v_file_name := C_BLACK_INFO_FILE||v_file_suffix;
      
      v_msg_text := 'Starting BLACK_INFO at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      v_msg_text := 'Writing to Directory: '||v_directory_name||' File: '||v_file_name;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);    

      v_file_handle := UTL_FILE.FOPEN(v_directory_name, v_file_name, 'W');

      FOR black_list_rec IN black_info_cur LOOP
        UTL_FILE.PUT_LINE(v_file_handle, black_list_rec.key1);
      END LOOP;
      UTL_FILE.FCLOSE(v_file_handle);   
      
      v_msg_text := 'Finished BLACK_INFO at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      
      v_msg_text := v_msg_text_header;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    END IF;
    -----------------------------------------
    -- Handle black_market
    -----------------------------------------  
    IF v_black_market_active =1 THEN
      v_file_name := C_BLACK_MARKET_FILE||v_file_suffix;
      
      v_msg_text := 'Starting BLACK_MARKET at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      v_msg_text := 'Writing to Directory: '||v_directory_name||' File: '||v_file_name;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);    

      v_file_handle := UTL_FILE.FOPEN(v_directory_name, v_file_name, 'W');

      FOR black_list_rec IN black_market_cur LOOP
        UTL_FILE.PUT_LINE(v_file_handle, black_list_rec.key1);
      END LOOP;
      UTL_FILE.FCLOSE(v_file_handle);   
      
      v_msg_text := 'Finished BLACK_MARKET at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    
      v_msg_text := v_msg_text_header;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    END IF;
    -----------------------------------------
    -- Handle black_tariff
    -----------------------------------------  
    IF v_black_tariff_active = 1 THEN
      v_file_name := C_BLACK_TARIFF_FILE||v_file_suffix;
      
      v_msg_text := 'Starting BLACK_TARIFF at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      v_msg_text := 'Writing to Directory: '||v_directory_name||' File: '||v_file_name;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);    

      v_file_handle := UTL_FILE.FOPEN(v_directory_name, v_file_name, 'W');

      FOR black_list_rec IN black_tariff_cur LOOP
        UTL_FILE.PUT_LINE(v_file_handle, black_list_rec.key1);
      END LOOP;
      UTL_FILE.FCLOSE(v_file_handle);   
      
      v_msg_text := 'Finished BLACK_TARIFF at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      
      v_msg_text := v_msg_text_header;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    END IF;
    -----------------------------------------
    -- Handle v_black_ext_trg_out
    -----------------------------------------  
    IF v_black_ext_trg_out_active = 1 THEN
      v_file_name := C_BLACK_EXT_TRG_OUT_FILE||v_file_suffix;
      
      v_msg_text := 'Starting BLACK_EXT_TRG_OUT at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      v_msg_text := 'Writing to Directory: '||v_directory_name||' File: '||v_file_name;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);    

      v_file_handle := UTL_FILE.FOPEN(v_directory_name, v_file_name, 'W');

      FOR black_list_rec IN black_ext_trg_out_cur LOOP
        UTL_FILE.PUT_LINE(v_file_handle, black_list_rec.key1);
      END LOOP;
      UTL_FILE.FCLOSE(v_file_handle);   
      
      v_msg_text := 'Finished BLACK_EXT_TRG_OUT at: '||SYSDATE;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      
      v_msg_text := v_msg_text_header;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    END IF;


  EXCEPTION
    WHEN OTHERS THEN
      v_msg_text := 'Unexpected Error. Error Details: '||SUBSTR(SQLERRM, 1, 900); 
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      RAISE;
      
  END REPORT_BLACK_LIST;
