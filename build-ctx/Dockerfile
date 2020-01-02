ARG CF_DEBIAN_RELEASE
ARG CF_DEBIAN_VERSION
ARG CF_CPUARCH_DEB_DIST

FROM tsle/os-debian-${CF_DEBIAN_RELEASE}-${CF_CPUARCH_DEB_DIST}:${CF_DEBIAN_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update \
	&& apt-get upgrade -y \
	&& apt-get dist-upgrade -y \
	&& apt-get install -y --no-install-recommends \
			python3 \
			python3-dev \
			python3-pip \
			build-essential \
			file

#
RUN \
	pip3 install \
			setuptools \
			wheel \
	&& pip3 install \
			Cython \
			# Jinja2 itself
			#Jinja2 \
			# j2cli (https://github.com/kolypto/j2cli)
			#j2cli[yaml] \
	&& echo -n

ARG CF_LIBYAML_VERSION
ARG CF_PYYAML_VERSION
ARG CF_JINJA2_VERSION
ARG CF_MARKUPSAFE_VERSION
ARG CF_J2CLI_VERSION

ADD files/yaml-${CF_LIBYAML_VERSION}.tgz /tmp/
ADD files/pyyaml-${CF_PYYAML_VERSION}.tgz /tmp/
ADD files/Jinja2-${CF_JINJA2_VERSION}.tgz /tmp/
ADD files/MarkupSafe-${CF_MARKUPSAFE_VERSION}.tgz /tmp/
ADD files/j2cli-${CF_J2CLI_VERSION}.tgz /tmp/

RUN \
	cd /tmp/yaml-* \
	&& echo -e "\n\nCompiling and installing LibYAML ${CF_LIBYAML_VERSION}...\n\n" \
	&& ./configure --prefix=/usr \
	&& make \
	&& make install \
	#
	&& cd /tmp/pyyaml-* \
	&& echo -e "\n\nCompiling and installing PyYAML ${CF_PYYAML_VERSION}...\n\n" \
	&& python3 setup.py --with-libyaml install \
	#
	&& cd /tmp/MarkupSafe-* \
	&& echo -e "\n\nCompiling and installing MarkupSafe ${CF_MARKUPSAFE_VERSION}...\n\n" \
	&& python3 setup.py install \
	#
	&& cd /tmp/Jinja2-* \
	&& echo -e "\n\nCompiling and installing Jinja2 ${CF_JINJA2_VERSION}...\n\n" \
	&& python3 setup.py install \
	#
	&& cd /tmp/j2cli-* \
	&& echo -e "\n\nCompiling and installing j2cli ${CF_J2CLI_VERSION}...\n\n" \
	&& python3 setup.py install

#
RUN \
	mkdir /root/app

#
RUN \
	apt-get --quiet --yes autoclean \
	&& apt-get --quiet --yes autoremove \
	&& apt-get --quiet --yes clean \
	&& rm -rf \
			/usr/share/man \
			/usr/share/doc \
			/usr/share/icons \
			/usr/share/poppler \
			/usr/share/mime \
			/var/lib/apt/lists*

#
ENV DEBIAN_FRONTEND=dialog

ENV CF_JINJA2_VERSION=$CF_JINJA2_VERSION
ENV CF_MARKUPSAFE_VERSION=$CF_MARKUPSAFE_VERSION
ENV CF_J2CLI_VERSION=$CF_J2CLI_VERSION

WORKDIR /root/app

VOLUME /root/app

#ENTRYPOINT ["/root/app/start.sh"]
