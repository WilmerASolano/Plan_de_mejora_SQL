CREATE OR REPLACE PROCEDURE prc_mover_estudiantes_cursor (
    p_periodo_origen IN VARCHAR2,
    p_nuevo_grupo    IN VARCHAR2
) 
IS
    -- Definimos el cursor que leerá solo los estudiantes del periodo específico
    CURSOR c_estudiantes IS
        SELECT num_identificacion, nom_largo 
        FROM estudiantes_ingles 
        WHERE periodo = p_periodo_origen;
        
    v_contador NUMBER := 0;
BEGIN
    -- Recorremos registro por registro
    FOR reg IN c_estudiantes LOOP
        
        -- Aquí podrías añadir lógica avanzada o validaciones (IF / ELSE)
        
        UPDATE estudiantes_ingles
        SET periodo = p_nuevo_grupo
        WHERE num_identificacion = reg.num_identificacion;
        
        v_contador := v_contador + 1;
    END LOOP;

    -- Auditoría al finalizar el loop
    INSERT INTO auditoria_procesos (usuario_db, fecha_accion, procedimiento, accion_realizada)
    VALUES (
        USER, 
        SYSDATE, 
        'PRC_MOVER_ESTUDIANTES_CURSOR',
        'Modificación por cursor completada. ' || v_contador || 
        ' estudiantes movidos al grupo ' || p_nuevo_grupo
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error de ejecución: ' || SQLERRM);
END prc_mover_estudiantes_cursor;
/
