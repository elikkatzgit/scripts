TRIGGER SPARX_crm_with_default_000
before INSERT
   ON SFI_CUSTOMER_PROFILE 
   referencing new as NEW
   FOR EACH ROW
   BEGIN 
	:new.ATTR1 :='000';
  :new.ATTR2 :='000';
  :new.ATTR3 :='000';
  :new.ATTR4 :='000';
  :new.ATTR5 :='000';
  :new.ATTR6 :='000';
  :new.ATTR7 :='000';
  :new.ATTR8 :='000';
  :new.ATTR9 :='000';
  :new.ATTR10 :='000';
  :new.ATTR11 :='000';
  :new.ATTR12 :='000';
  :new.ATTR13 :='000';
  :new.ATTR14 :='000';
  :new.ATTR15 :='000';
END;