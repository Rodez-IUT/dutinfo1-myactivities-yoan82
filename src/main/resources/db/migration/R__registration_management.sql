--
-- Function to register a given user from a given activity
--
CREATE OR REPLACE FUNCTION 	register_user_on_activity(in_user_id bigint, in_activity_id bigint) 
	RETURNS registration AS $$

	DECLARE
		res_registration registration%rowtype; -- Type qui correspond a une ligne de la table registration
		
	BEGIN
		-- On vérifie l'existence de la variable			  
		SELECT * INTO res_registration 
		FROM registration 
		WHERE user_id = in_user_id 
		AND activity_id = in_activity_id;
		IF FOUND THEN  -- Positionné a true si variable mise à jour ou sinon positionné a false
			RAISE EXCEPTION 'registration_already_exists'; 
		END IF;
		
		-- on insère la ligne 
		INSERT INTO registration (id, user_id, activity_id)
		VALUES (nextval('id_generator'), in_user_id, in_activity_id);
		
		-- On retourne le résultat qui est la ligne registration
		SELECT * INTO res_registration 
		FROM registration
		WHERE user_id = in_user_id 
		AND activity_id = in_activity_id;		
		RETURN res_registration;
	END;
$$ LANGUAGE plpgsql;


--
-- Trigger to log in action_log table registration insertion
--

DROP TRIGGER IF EXISTS log_insert_registration on registration;

CREATE OR REPLACE FUNCTION log_insert_registration() 
	RETURNS TRIGGER AS $$
	
	BEGIN
		INSERT INTO action_log (id, action_name, entity_name, entity_id, author , action_date)
		VALUES (nextval('id_generator '), 'insert', 'registration', NEW.id, user, now());
	END;
		
$$ LANGUAGE plpgsql;
	
CREATE TRIGGER log_insert_registration
	AFTER INSERT 
	ON registration 
	FOR EACH ROW 
EXECUTE PROCEDURE log_insert_registration();


--
-- Function to unregister a given user from a given activity
--

CREATE OR REPLACE FUNCTION 	unregister_user_on_activity(in_user_id bigint, in_activity_id bigint) 
	RETURNS VOID AS $$

	DECLARE
		res_registration registration%rowtype; -- Type qui correspond a une ligne de la table registration
		
	BEGIN
		-- Check existence
		SELECT * INTO res_registration 
		FROM registration 
		WHERE user_id = in_user_id 
		AND activity_id = in_activity_id;
		IF NOT FOUND THEN  
			RAISE EXCEPTION 'registration_not_found'; 
		END IF;

		-- Delete
	    DELETE 
	    FROM registration
	    WHERE user_id = in_user_id
	    AND activity_id = in_activity_in;
	END;
	
$$ LANGUAGE plpgsql;


--
-- Trigger to log unregistration in action_log table
--

DROP TRIGGER IF EXISTS log_delete_registration ON registration;

CREATE OR REPLACE FUNCTION log_delete_registration() 
	RETURNS TRIGGER AS $$
	
	BEGIN
		INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
		VALUES (nextval('id_generator'), 'delete', 'registration', OLD.id, user, now());
		RETURN NULL; -- Le résultat est ignoré	
	END;
$$ language plpgsql;

CREATE TRIGGER log_delete_registration
	AFTER DELETE 
	ON registration 
	FOR EACH ROW 
EXECUTE PROCEDURE log_delete_registration();