CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$
	DECLARE
		defaultOwner "user"%ROWTYPE;
		defaultOwnerUsername VARCHAR(500) := 'Default Owner';

	BEGIN
		SELECT * INTO defaultOwner FROM "user"
			WHERE username = defaultOwnerUserName;
		IF NOT FOUND THEN
			INSERT INTO "user" (id, username)
				values (nextval('id_generator'),defaultOwnerUsername);
			SELECT * INTO defaultOwner FROM "user"
				WHERE username = defaultOwnerUsername;
		END IF;
		RETURN defaultOwner;
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity as $$
	DECLARE
		defaultOwner "user"%rowtype;
		nowDate DATE = now();
	BEGIN
		defaultOwner := get_default_owner();
		RETURN QUERY
		UPDATE activity
		SET owner_id = defaultOwner.id, -- on recupère l'ID
			modification_date = nowDate
			WHERE owner_id IS NULL
			RETURNING *;	
	END;
$$ LANGUAGE plpgsql;

	
