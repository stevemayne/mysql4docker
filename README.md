mysql4docker
============

Dockerfile to create a MySQL4 environment for legacy testing purposes

Usage
=====

Specify the MYSQL_ROOT_PASSWORD environment variable when launching a new container, e.g:

<pre><code>docker run -d -P -e "MYSQL_ROOT_PASSWORD=password" stevemayne/mysql4</code></pre>

Root user will be bound to the wildcard % host to allow login from outside the container.