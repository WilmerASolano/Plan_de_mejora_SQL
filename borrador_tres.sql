CREATE OR REPLACE TRIGGER trg_audi_bi

  BEFORE INSERT ON auditoria_procesos
  FOR EACH ROW
    BEGIN
      SELECT audi_seq.nextval
      INTO : NEW.id_auditoria
      FROM dual;



END;
