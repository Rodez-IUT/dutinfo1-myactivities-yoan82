CREATE OR REPLACE FUNCTION delete_activities_older_than(old_date date) RETURNS void AS $$
   DELETE FROM activity WHERE activity.modification_date < old_date;
$$ LANGUAGE SQL; 