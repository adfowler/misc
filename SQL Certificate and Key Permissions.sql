GRANT CONTROL TO MW_Admin

GRANT ALTER ANY SYMMETRIC KEY TO [MW_Admin]

GRANT VIEW DEFINITION ON CERTIFICATE::[PII] TO [MW_Admin]

GRANT CONTROL ON CERTIFICATE::[PII] TO [MW_Admin]

--MW_Admin needs this to create some of the procedure that update IP locations.
--GRANT ALTER TRACE TO [MW_Admin]