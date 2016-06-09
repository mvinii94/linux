FROM ubuntu

# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install -y wget net-tools build-essential git curl

# Download Arachni
RUN cd /opt/ && wget -q -O arachni.tar.gz "https://github.com/Arachni/arachni/releases/download/v1.4/arachni-1.4-0.5.10-linux-x86_64.tar.gz"

# Setup Arachni
RUN cd /opt/ && tar xzfv arachni.tar.gz && mv arachni-1.4-0.5.10 arachni
RUN chmod -Rf +x /opt/arachni/bin/*

# EXPOSE
EXPOSE 7331

# CMD ON INIT
CMD ["/opt/arachni/bin/arachni_rest_server","--address","0.0.0.0"]
