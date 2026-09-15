CREATE OR REPLACE PROCEDURE prc_actualizar_periodo_masivo (
    p_periodo_origen IN VARCHAR2,
    p_nuevo_grupo    IN VARCHAR2
) 
IS
    v_filas_actualizadas NUMBER;
BEGIN
    -- Actualización de estudiantes
    UPDATE estudiantes_ingles
    SET periodo = p_nuevo_grupo
    WHERE periodo = p_periodo_origen;

    v_filas_actualizadas := SQL%ROWCOUNT;

    -- Inserción en auditoría usando la secuencia para el ID
    INSERT INTO auditoria_procesos (
        id_auditoria, 
        usuario_db, 
        fecha_accion, 
        procedimiento, 
        accion_realizada
    )
    VALUES (
        seq_auditoria.NEXTVAL, -- Aquí llamamos al autoincremental
        USER, 
        SYSDATE, 
        'PRC_ACTUALIZAR_PERIODO_MASIVO',
        'Se movieron ' || v_filas_actualizadas || 
        ' estudiantes del periodo ' || p_periodo_origen || 
        ' al ' || p_nuevo_grupo
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso exitoso. Filas actualizadas: ' || v_filas_actualizadas);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error de ejecución: ' || SQLERRM);
END prc_actualizar_periodo_masivo;
/
