from ubuntu:14.04
RUN apt-get update
RUN apt-get install -y socat
RUN echo "This file is shared between different containers" > shared.txt
CMD socat -d -d TCP-LISTEN:9001,fork SYSTEM:'cat shared.txt'
