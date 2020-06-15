-- Create trigger to prevent users from entering project hours for future dates
CREATE OR REPLACE TRIGGER trig_stop_logging_future_hours
  BEFORE UPDATE OR INSERT ON PROJECTHOURS
  FOR EACH ROW
DECLARE
  todays_date DATE;

BEGIN
  todays_date := SYSDATE;

  IF :NEW.WORKEDDATE > todays_date THEN
    RAISE_APPLICATION_ERROR(-20600, 'Transaction rejected. Logging hours for days in the future is not allowed.');
  END IF;

END;
