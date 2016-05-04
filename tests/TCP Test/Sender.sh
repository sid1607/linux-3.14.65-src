#!/bin/sh

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
args_parsed=

# Initialize our own variables:
num_packets=1024

set_delay=
delay_ms=0

dump_packets=

ip_to_send=""
port_to_send=""

function show_help {
    echo "Usage:" >&2
    echo "  -h  Show help (this)" >&2
    echo "  -n  Number of packets to send (default: 1024)" >&2
    echo "  -d  Delay tolerance option in milliseconds (default: off)" >&2
    echo "  -a  Destination IP address" >&2
    echo "  -p  Destination port" >&2
    echo "  -s  Dump packets (default: off) (requires superuser privileges)" >&2
}

function print_options {
    echo "Destination: $ip_to_send:$port_to_send" >&2
    echo "Number of packets to send: $num_packets" >&2
    if [[ "$set_delay" == true ]]; then
        echo "Application delay: $delay_ms ms" >&2
    else
        echo "Application delay: off" >&2
    fi
    if [[ "$dump_packets" == true ]]; then
        echo "Packet dump: on" >&2
    else
        echo "Packet dump: off" >&2
    fi
    echo
}

# Parse arguments
options=":hn:d:a:p:s"

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
    s)  dump_packets=true
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

# Check if required arguments are provided
if [[ "$ip_to_send" == "" ]] || [[ "$port_to_send" == "" ]]; then
    show_help
    exit 0
else
    args_parsed=true
fi

# Print the options passed to the script
print_options

# if [[ "$dump_packets" == true ]]; then
#     # Start capturing packets
#     tcpdump -q -nn -w test_dump.pcap tcp and dst port $port_to_send and dst host $ip_to_send
# fi

# Start the transfer
python Sender.py -a "$ip_to_send" -p $port_to_send -n $num_packets -d $delay_ms
