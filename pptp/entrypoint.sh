#!/bin/sh

SERVER_IP="$(getent hosts "$SERVER" | awk '{ print $1 }')"

cat > "/etc/ppp/peers/${SERVER}" <<_EOF_
pty "pptp ${SERVER_IP} --nolaunchpppd"
name "${USERNAME}"
password "${PASSWORD}"
remotename PPTP
require-mppe-128
file /etc/ppp/options.pptp
ipparam "${SERVER}"
_EOF_

cat > /etc/ppp/ip-up <<"_EOF_"
#!/bin/sh
ip route add 0.0.0.0/1 dev $1
ip route add 128.0.0.0/1 dev $1
_EOF_

cat > /etc/ppp/ip-down <<"_EOF_"
#!/bin/sh
ip route del 0.0.0.0/1 dev $1
ip route del 128.0.0.0/1 dev $1
_EOF_

ip route add "$SERVER_IP" via "$(ip route | awk '/default/{print $3}')" dev eth0
ip route del default

exec pon "${SERVER}" debug dump logfd 2 nodetach persist "$@"

