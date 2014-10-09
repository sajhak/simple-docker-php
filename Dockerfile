# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

FROM ubuntu:14.04

MAINTAINER Sajith Kariyawasam

RUN apt-get update

#################################
# Enable ssh - This is not good. http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/
# For experimental purposes only
##################################

RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:g' | chpasswd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config

##################
# Install PHP
##################
RUN apt-get install -y apache2 php5 zip unzip
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD files/000-default.conf /etc/apache2/sites-enabled/000-default.conf

######################
# Copy sample php page
######################
ADD files/info.php /var/www

###############
# Expose ports
###############
EXPOSE 22 80

###################
# Setup run script
###################
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

ENTRYPOINT /usr/local/bin/run | /usr/sbin/sshd -D
