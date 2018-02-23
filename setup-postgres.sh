#!/bin/bash
set -e

brew services start postgresql

# Is postgres running?
for i in $(seq 60); do
	if brew services list | grep postgresql | grep -q started; then
		break
	else
		sleep 1
	fi
done

# Change the admin password
if ! psql -U postgres -c "select 1" &> /dev/null; then
	echo "Setting postgres user"
	createuser -U "$(whoami)" --superuser postgres
else
	echo "postgres user already created"
fi	
