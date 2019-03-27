DROP TRIGGER IF EXISTS log_delete_activity on activity;
CREATE OR REPLACE FUNCTION log_delete_activity() RETURNS TRIGGER AS $$
	BEGIN
      INSER INTO action_log VALUES (id, action_name, entity_name, entity_id, author, action_date);
      VALUES (nextval('id_generator'), 'delete', 'activity', OLD.id, user, now());
	RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_delete_activity
	AFTER DELETE ON activity
    FOR EACH ROW EXECUTE PROCEDURE log_delete_activity();
    
   