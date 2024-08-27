FROM flyway/flyway

RUN mkdir -p /flyway/sql
COPY sql/*.sql /flyway/sql

ENTRYPOINT flyway \
  -url=jdbc:postgresql://postgres:5432/the_database \
  -schemas=public \
  -user=db_user \
  -password=db_pass \
  -baselineVersion=0 \
  -baselineOnMigrate="true" \
  -locations=filesystem:/flyway/sql migrate
