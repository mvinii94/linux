FROM debian:stable

# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install -y wget net-tools build-essential git curl

# Download Arachni
RUN cd /opt/ && wget -q -O arachni.tar.gz "https://github.com/Arachni/arachni/releases/download/v1.4/arachni-1.4-0.5.10-linux-x86_64.tar.gz"

# Install Nginx and Ruby
RUN cd /opt/ && tar xzfv arachni.tar.gz && mv arachni-1.4-0.5.10 arachni
RUN echo "nohup /opt/arachni/bin/arachni_rest_server &" >> /etc/rc.local
RUN echo "nohup /opt/arachni/bin/arachni_web -o 0.0.0.0 -p 8080 &" >> /etc/rc.local

# Ports
EXPOSE 8080
EXPOSE 7331

#WORKDIR
WORKDIR /opt

#RUN
CMD ["./start.sh"]
