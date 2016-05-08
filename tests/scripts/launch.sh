#!/bin/sh

srcdir="$(dirname "$0")"

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
args_parsed=

# Initialize our own variables:
num_packets=1024

set_delay=
delay_ms=0

run_time=""

dump_packets=

client_program="$srcdir/client.py"
server_program="$srcdir/server.py"

program_to_run=""

ip_to_send="0.0.0.0"
port_to_send="15744"

show_help() {
    echo "Usage:" >&2
    echo "  -h  Show help (this)" >&2
    echo "  -n  Number of packets to send (default: 1024)" >&2
    echo "  -d  Delay tolerance option in milliseconds (default: off)" >&2
    echo "  -a  Destination IP address (default: localhost)" >&2
    echo "  -p  Destination port (default: 15744)" >&2
    echo "  -r  Program to run (values: client, server)" >&2
    echo "  -s  Dump packets (default: off) (requires superuser privileges)" >&2
    echo "  -t  Run time in s" >&2
}

print_options() {
    echo "Destination: $ip_to_send:$port_to_send" >&2
    echo "Number of packets to send: $num_packets" >&2
    if [ "$set_delay" = true ]; then
        echo "Application delay: $delay_ms ms" >&2
    else
        echo "Application delay: off" >&2
    fi
    if [ "$dump_packets" = true ]; then
        echo "Packet dump: on" >&2
    else
        echo "Packet dump: off" >&2
    fi
    echo
}

# Parse arguments
options=":hn:d:a:p:s:r:t:o:"

while getopts $options opt; do
    case "$opt" in
    h)  show_help
        exit 0
        ;;
    n)  num_packets=$OPTARG
        ;;
    d)  delay_ms=$OPTARG
        set_delay=true
        ;;
    a)  ip_to_send=$OPTARG
        ;;
    p)  port_to_send=$OPTARG
        ;;
    r)  if [ "$OPTARG" = "client" ]; then
            program_to_run=$client_program
        elif [ "$OPTARG" = "server" ]; then
            program_to_run=$server_program
        else
            echo "Invalid program: $OPTARG"
            show_help
            exit 1
        fi
        ;;
    s)  dump_packets=true
        ;;
    t)  run_time=$OPTARG
        ;;

    \?) echo "Invalid option: -$OPTARG" >&2
        show_help
        exit 1
        ;;
    :)  echo "Option -$OPTARG requires an argument." >&2
        show_help
        exit 1
        ;;
    esac
done

# Check if a program has been specified
if [ "$program_to_run" = "" ]; then
    echo "Specify a program to run (client or server)"
    show_help
    exit 1
fi

if [ "$run_time" = "" ]; then
    echo "Specify a run time"
    show_help
    exit 1
fi

# Check if required arguments are provided
if [ "$ip_to_send" = "" ] || [ "$port_to_send" = "" ]; then
    show_help
    exit 1
else
    args_parsed=true
fi

# Print the options passed to the script
print_options

# if [[ "$dump_packets" == true ]]; then
#     # Start capturing packets
#     tcpdump -q -nn -w test_dump.pcap tcp and dst port $port_to_send and dst host $ip_to_send
# fi

# Start the program
if [ "$program_to_run" = "$client_program" ]; then
    python $program_to_run -a $ip_to_send -p $port_to_send -n $num_packets -d $delay_ms &
    pid=$!
else
    python $program_to_run -a $ip_to_send -p $port_to_send &
    pid=$!
fi

# sleep till the run time
sleep $run_time

echo "Killing:$pid"
# kill the process
kill $pid
