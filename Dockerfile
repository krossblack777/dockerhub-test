# Dockerfile
FROM centos:centos6

MAINTAINER test

RUN yum update -y

# install package
RUN yum -y install passwd openssh openssh-server openssh-clients sudo rsync git vim && \
    curl -L https://www.opscode.com/chef/install.sh | bash && \

# Create user
    useradd docker && \
    passwd -f -u docker && \

# Set up SSH
    mkdir -p /home/docker/.ssh; chown docker /home/docker/.ssh; chmod 700 /home/docker/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYcP2L++0HL2Ry+dFzHvuVL5nuA7Lqmbq06tE8vCXMvpTx9Okd0v947givvya8r7XZtOPoxDPw5szt2qIx4zkatsDOK9CVD5YRWT7cAgbgSbOLT+U48qCyOQogZSj+JFWvjmUYyrsRp3Pzovp4C8b55rqVFSH7HeUQ2DPBWVNNi27s4d8FpZ4UdDmz8Y6oLx1OKY9WRyc00AiO2KD+FBCWNzQOLVTD2z8VSHG5jKYpJCS8mYltiwERqmj2uIwaRK8oEqB02RyN9nsAfKhmPsDofIIldaROKNmJ8r3fYJbTk4+KFiSqxb8RjgENwpHsYOvAlPCD+W0H7fvCMFbsb9U3 docker" > /home/docker/.ssh/authorized_keys && \
    chown docker /home/docker/.ssh/authorized_keys && \
    chmod 600 /home/docker/.ssh/authorized_keys && \

# setup sudoers
    echo "docker ALL=(ALL) ALL" >> /etc/sudoers.d/docker && \

# Set up SSHD config

    sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    # PAMを利用するときには下記をオフにしないとSSHログインできない
    #sed -i -e 's/^\(session.*pam_loginuid.so\)/#\1/g' /etc/pam.d/sshd && \


# Init SSHD
    /etc/init.d/sshd start && \
    /etc/init.d/sshd stop

#
#EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
