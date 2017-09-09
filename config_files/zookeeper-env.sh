# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
export JAVA_HOME=${JAVA_HOME}
export ZOO_LOG_DIR="/usr/local/zookeeper/logs"

export SERVER_JVMFLAGS="-Djava.security.auth.login.config=/usr/local/zookeeper/conf/zookeeper-server.jaas"
export CLIENT_JVMFLAGS="-Djava.security.auth.login.config=/usr/local/zookeeper/conf/zookeeper-client.jaas -Dsun.net.spi.nameservice.provider.1=dns,sun"
