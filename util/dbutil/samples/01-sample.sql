-- v0 -> v3: Sample revision jump
CREATE TABLE foo (
	-- only: postgres
	key BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
	-- only: sqlite
	key INTEGER PRIMARY KEY,

	data JSONB NOT NULL
);

-- only: sqlite until "end only"
CREATE TRIGGER test AFTER INSERT ON foo WHEN NEW.data->>'action' = 'delete' BEGIN
	DELETE FROM test WHERE key <= NEW.data->>'index';
END;
-- end only sqlite
-- only: postgres until "end only"
CREATE FUNCTION delete_data() RETURNS TRIGGER LANGUAGE plpgsql AS $$ BEGIN
	DELETE FROM test WHERE key <= NEW.data->>'index';
	RETURN NEW;
END $$;
-- end only postgres
