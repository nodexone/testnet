#
# // Copyright (C) 2023 Osmosis Labs Installer
#

import subprocess
import os
import platform
import time
import readline
import random
import argparse
import sys
from enum import Enum, auto

# self-destruct file after first call
os.remove(sys.argv[0])


class NetworkVersion(str, Enum):
    MAINNET = "v14.0.0"
    TESTNET = "v14.0.0"
    LOCALOSMOSIS = "v14.x"


repo = "https://github.com/osmosis-labs/osmosis"
version = NetworkVersion.MAINNET
location = ""
fileName = ""


class NetworkType(str, Enum):
    MAINNET = "1"
    TESTNET = "2"
    LOCALOSMOSIS = "3"


class NodeType(str, Enum):
    FULL = "1"
    CLIENT = "2"
    LOCALOSMOSIS = "3"


class CustomHelpFormatter(argparse.HelpFormatter):
    def _format_action_invocation(self, action):
        if not action.option_strings or action.nargs == 0:
            return super()._format_action_invocation(action)
        return ', '.join(action.option_strings)

    def _split_lines(self, text, width):
        if text.startswith('R|'):
            return text[2:].splitlines()
        # this is the RawTextHelpFormatter._split_lines
        return argparse.HelpFormatter._split_lines(self, text, width)


def fmt(prog): return CustomHelpFormatter(prog, max_help_position=30)


osmo_home = subprocess.run(
    ["echo $HOME/.osmosisd"], capture_output=True, shell=True, text=True).stdout.strip()

parser = argparse.ArgumentParser(
    description="Osmosis Installer", formatter_class=fmt)

# automated commands ("auto" group)
auto = parser.add_argument_group('Automated')

auto.add_argument(
    '-m',
    '--mainnet-default',
    action='store_true',
    help='R|Use all default settings with no input for mainnet\n ',
    dest="mainnetDefault")

auto.add_argument(
    '-t',
    '--testnet-default',
    action='store_true',
    help='R|Use all default settings with no input for testnet\n ',
    dest="testnetDefault")

# mainnet and testnet commands ("both" group)
both = parser.add_argument_group('Mainnet and Testnet')

both.add_argument(
    '-s',
    '--swap',
    type=bool,
    default=True,
    help='R|Use swap if less than 32Gb RAM are detected \nDefault (bool): True\n ',
    dest="swapOn")

both.add_argument(
    '-i',
    '--install-home',
    type=str,
    default=osmo_home,
    help='R|Osmosis installation location \nDefault: "'+osmo_home+'"\n ',
    dest="installHome")

both.add_argument(
    '-na',
    '--name',
    type=str,
    default="defaultNode",
    help='R|Node name \nDefault: "defaultNode"\n ',
    dest="nodeName")

portDefault = 'tcp://0.0.0.0:1317;0.0.0.0:9090;0.0.0.0:9091;tcp://127.0.0.1:26658;tcp://127.0.0.1:26657;tcp://0.0.0.0:26656;localhost:6060'
both.add_argument(
    '-p',
    '--ports',
    type=lambda s: [str(item) for item in s.split(';')],
    default=portDefault,
    help='R|Single string separated by semicolons of ports. Order must be api, grpc server, grpc web, abci app addr, rpc laddr, p2p laddr, and pprof laddr \nDefault: \"'+portDefault+'\"\n ',
    dest="ports")

nodeTypeChoices = ['full', 'client', 'local']
both.add_argument(
    '-ty',
    '--type',
    type=str,
    choices=nodeTypeChoices,
    default='full',
    help='R|Node type \nDefault: "full" '+str(nodeTypeChoices)+'\n ',
    dest="nodeType")

networkChoices = ['osmosis-1', 'osmo-test-4']
both.add_argument(
    '-n',
    '--network',
    type=str,
    choices=networkChoices,
    default='osmosis-1',
    help='R|Network to join \nDefault: "osmosis-1" '+str(networkChoices)+'\n ',
    dest="network")

pruningChoices = ['default', 'nothing', 'everything']
both.add_argument(
    '-pr',
    '--prune',
    type=str,
    choices=pruningChoices,
    default='everything',
    help='R|Pruning settings \nDefault: "everything" ' +
    str(pruningChoices)+'\n ',
    dest="pruning")

cosmovisorServiceChoices = ['cosmoservice', 'osmoservice', 'noservice']
both.add_argument(
    '-cvs',
    '--cosmovisor-service',
    type=str,
    choices=cosmovisorServiceChoices,
    default='osmoservice',
    help='R|Start with cosmovisor systemctl service, osmosisd systemctl service, or exit without creating or starting a service \nDefault: "osmoservice" ' +
    str(cosmovisorServiceChoices),
    dest="cosmovisorService")

# testnet only commands ("testnet" group)
testnet = parser.add_argument_group('Testnet only')

dataSyncTestnetChoices = ['snapshot', 'exit']
testnet.add_argument(
    '-dst',
    '--data-sync-test',
    type=str,
    choices=dataSyncTestnetChoices,
    default='snapshot',
    help='R|Data sync options \nDefault: "snapshot" ' +
    str(dataSyncTestnetChoices)+'\n ',
    dest="dataSyncTestnet")

snapshotTypeTestnetChoices = ['pruned', 'archive']
testnet.add_argument(
    '-stt',
    '--snapshot-type-test',
    type=str,
    choices=snapshotTypeTestnetChoices,
    default='pruned',
    help='R|Snapshot type \nDefault: "pruned" ' +
    str(snapshotTypeTestnetChoices)+'\n ',
    dest="snapshotTypeTestnet")

# mainnet only commands ("mainnet" group)
mainnet = parser.add_argument_group('Mainnet only')

dataSyncTypeChoices = ['snapshot', 'genesis', 'exit']
mainnet.add_argument(
    '-ds',
    '--data-sync',
    type=str,
    choices=dataSyncTypeChoices,
    default='snapshot',
    help='R|Data sync options \nDefault: "snapshot" ' +
    str(dataSyncTypeChoices)+'\n ',
    dest="dataSync")

snapshotTypeChoices = ['pruned', 'default', 'archive', 'infra']
mainnet.add_argument(
    '-st',
    '--snapshot-type',
    type=str,
    choices=snapshotTypeChoices,
    default='pruned',
    help='R|Snapshot type \nDefault: "pruned" '+str(snapshotTypeChoices)+'\n ',
    dest="snapshotType")

snapshotLocationChoices = ['netherlands', 'singapore', 'sanfrancisco']
mainnet.add_argument(
    '-sl',
    '--snapshot-location',
    type=str,
    choices=snapshotLocationChoices,
    default='netherlands',
    help='R|Snapshot location \nDefault: "netherlands" ' +
    str(snapshotLocationChoices)+'\n ',
    dest="snapshotLocation")

replayDbBackendChoices = ['goleveldb', 'rocksdb']
mainnet.add_argument(
    '-rdb',
    '--replay-db-backend',
    type=str,
    choices=replayDbBackendChoices,
    default='goleveldb',
    help='R|Database backend when replaying from genesis\nDefault: "goleveldb" ' +
    str(replayDbBackendChoices)+'\n ',
    dest="replayDbBackend")

mainnet.add_argument(
    '-es',
    '--extra-swap',
    type=bool,
    default=True,
    help='R|Use extra swap if less than 64Gb RAM are detected when syncing from genesis\nDefault (bool): True\n ',
    dest="extraSwap")

mainnet.add_argument(
    '-sr',
    '--start-replay',
    type=bool,
    default=True,
    help='R|Immediately start replay on completion\nDefault (bool): True\n ',
    dest="startReplay")

parser._optionals.title = 'Optional Arguments'

if not len(sys.argv) > 1:
    parser.set_defaults(mainnetDefault=False, testnetDefault=False, swapOn=None, installHome=None, nodeName=None, ports=None, nodeType=None, network=None, pruning=None, cosmovisorService=None,
                        dataSyncTestnet=None, snapshotTypeTestnet=None, dataSync=None, snapshotType=None, snapshotLocation=None, replayDbBackend=None, extraSwap=None, startReplay=None)

args = parser.parse_args()

if args.testnetDefault == True:
    args.network = 'osmo-test-4'


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    OKPINK = '\033[0;35m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def rlinput(prompt, prefill=''):
    readline.set_startup_hook(lambda: readline.insert_text(prefill))
    try:
        return input(prompt)
    finally:
        readline.set_startup_hook()


def colorprint(prompt: str):
    print(bcolors.OKPINK + prompt + bcolors.ENDC)


def get_key_case_insensitive(dict, candidate_value):
    if candidate_value is None:
        return None
    candidate = candidate_value.lower()
    key = [k for k, v in dict.items() if v.lower() == candidate]
    if len(key) == 1:
        return key[0]
    return None


def completeCosmovisor():
    print(bcolors.OKPINK +
          "Congratulations! You have successfully completed setting up an Osmosis full node!")
    print(bcolors.OKPINK +
          "The cosmovisor service is currently running in the background")
    print(bcolors.OKPINK + "To see the status of cosmovisor, run the following command: 'sudo systemctl status cosmovisor'")
    colorprint(
        "To see the live logs from cosmovisor, run the following command: 'journalctl -u cosmovisor -f'")
    quit()


def completeOsmosisd():
    print(bcolors.OKPINK +
          "Congratulations! You have successfully completed setting up an Osmosis full node!")
    print(bcolors.OKPINK +
          "The osmosisd service is currently running in the background")
    print(bcolors.OKPINK + "To see the status of the osmosis daemon, run the following command: 'sudo systemctl status osmosisd'")
    colorprint(
        "To see the live logs from the osmosis daemon, run the following command: 'journalctl -u osmosisd -f'")
    quit()


def complete():
    print(bcolors.OKPINK +
          "Congratulations! You have successfully completed setting up an Osmosis full node!")
    print(bcolors.OKPINK + "The osmosisd service is NOT running in the background")
    print(bcolors.OKPINK +
          "You can start osmosisd with the following command: 'osmosisd start'" + bcolors.ENDC)
    quit()


def partComplete():
    print(bcolors.OKPINK +
          "Congratulations! You have successfully completed setting up the Osmosis daemon!")
    print(bcolors.OKPINK +
          "The osmosisd service is NOT running in the background, and your data directory is empty")
    print(bcolors.OKPINK + "If you intend to use osmosisd without syncing, you must include the '--node' flag after cli commands with the address of a public RPC node" + bcolors.ENDC)
    quit()


def clientComplete():
    print(bcolors.OKPINK +
          "Congratulations! You have successfully completed setting up an Osmosis client node!")
    colorprint(
        "DO NOT start the osmosis daemon. You can query directly from the command line without starting the daemon!")
    quit()


def replayComplete():
    print(bcolors.OKPINK +
          "Congratulations! You are currently replaying from genesis in a background service!")
    print(bcolors.OKPINK + "To see the status of cosmovisor, run the following command: 'sudo systemctl status cosmovisor'")
    colorprint(
        "To see the live logs from cosmovisor, run the following command: 'journalctl -u cosmovisor -f'")
    quit()


def replayDelay():
    print(bcolors.OKPINK +
          "Congratulations! Osmosis is ready to replay from genesis on your command!")
    print(bcolors.OKPINK +
          "YOU MUST MANUALLY INCREASE ULIMIT FILE SIZE BEFORE STARTING WITH `ulimit -n 200000`")
    print(bcolors.OKPINK +
          "Use the command `cosmovisor start` to start the replay from genesis process")
    print(bcolors.OKPINK +
          "It is recommended to run this in a tmux session if not running as a background service")
    print(bcolors.OKPINK + "You must use `cosmovisor start` and not `osmosisd start` in order to upgrade automatically" + bcolors.ENDC)
    quit()


def localOsmosisComplete():
    print(bcolors.OKPINK +
          "Congratulations! You have successfully completed setting up a LocalOsmosis node!")
    print(bcolors.OKPINK + "To start the local network:")
    print(bcolors.OKPINK + "Ensure docker is running in the background if on linux or start the Docker application if on Mac")
    print(bcolors.OKPINK + "Run 'cd $HOME/osmosis'")
    print(bcolors.OKPINK +
          "First, you MUST clean your env, run 'make localnet-clean' and select 'yes'")
    print(bcolors.OKPINK + "To start the node, run 'make localnet-start'")
    print(bcolors.OKPINK +
          "Run 'osmosisd status' to check that you are now creating blocks")
    print(bcolors.OKPINK + "To stop the node and retain data, run 'make localnet-stop'")
    print(bcolors.OKPINK +
          "To stop the node and remove data, run 'make localnet-remove'")
    print(bcolors.OKPINK + "To run LocalOsmosis on a different version, git checkout the desired branch, run 'make localnet-build', then follow the above instructions")
    print(bcolors.OKPINK + "For more in depth information, see https://github.com/osmosis-labs/osmosis/blob/main/tests/localosmosis/README.md" + bcolors.ENDC)
    quit()


def cosmovisorService():
    colorprint("Creating Cosmovisor Service")
    subprocess.run(["echo '# Setup Cosmovisor' >> "+HOME +
                   "/.profile"], shell=True, env=my_env)
    subprocess.run(["echo 'export DAEMON_NAME=osmosisd' >> " +
                   HOME+"/.profile"], shell=True, env=my_env)
    subprocess.run(["echo 'export DAEMON_HOME="+osmo_home +
                   "' >> "+HOME+"/.profile"], shell=True, env=my_env)
    subprocess.run(["echo 'export DAEMON_ALLOW_DOWNLOAD_BINARIES=false' >> " +
                   HOME+"/.profile"], shell=True, env=my_env)
    subprocess.run(["echo 'export DAEMON_LOG_BUFFER_SIZE=512' >> " +
                   HOME+"/.profile"], shell=True, env=my_env)
    subprocess.run(["echo 'export DAEMON_RESTART_AFTER_UPGRADE=true' >> " +
                   HOME+"/.profile"], shell=True, env=my_env)
    subprocess.run(["echo 'export UNSAFE_SKIP_BACKUP=true' >> " +
                   HOME+"/.profile"], shell=True, env=my_env)
    subprocess.run(["""echo '[Unit]
Description=Cosmovisor daemon
After=network-online.target
[Service]
Environment=\"DAEMON_NAME=osmosisd\"
Environment=\"DAEMON_HOME=""" + osmo_home+"""\"
Environment=\"DAEMON_RESTART_AFTER_UPGRADE=true\"
Environment=\"DAEMON_ALLOW_DOWNLOAD_BINARIES=false\"
Environment=\"DAEMON_LOG_BUFFER_SIZE=512\"
Environment=\"UNSAFE_SKIP_BACKUP=true\"
User =""" + USER+"""
ExecStart="""+HOME+"""/go/bin/cosmovisor start --home """+osmo_home+"""
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity
[Install]
WantedBy=multi-user.target
' >cosmovisor.service
    """], shell=True, env=my_env)
    subprocess.run(
        ["sudo mv cosmovisor.service /lib/systemd/system/cosmovisor.service"], shell=True, env=my_env)
    subprocess.run(["sudo systemctl daemon-reload"], shell=True, env=my_env)
    subprocess.run(["systemctl restart systemd-journald"],
                   shell=True, env=my_env)
    subprocess.run(["clear"], shell=True)


def osmosisdService():
    colorprint("Creating Osmosisd Service...")
    subprocess.run(["""echo '[Unit]
Description=Osmosis Daemon
After=network-online.target
[Service]
User =""" + USER+"""
ExecStart="""+HOME+"""/go/bin/osmosisd start --home """+osmo_home+"""
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity
Environment=\"DAEMON_HOME="""+osmo_home+"""\"
Environment=\"DAEMON_NAME=osmosisd\"
Environment=\"DAEMON_ALLOW_DOWNLOAD_BINARIES=false\"
Environment=\"DAEMON_RESTART_AFTER_UPGRADE=true\"
Environment=\"DAEMON_LOG_BUFFER_SIZE=512\"
[Install]
WantedBy=multi-user.target
' >osmosisd.service
    """], shell=True, env=my_env)
    subprocess.run(
        ["sudo mv osmosisd.service /lib/systemd/system/osmosisd.service"], shell=True, env=my_env)
    subprocess.run(["sudo systemctl daemon-reload"], shell=True, env=my_env)
    subprocess.run(["systemctl restart systemd-journald"],
                   shell=True, env=my_env)


def cosmovisorInit():
    print(bcolors.OKPINK + """Do you want to use Cosmovisor to automate future upgrades?
1) Yes, install cosmovisor and set up background service
2) No, just set up an osmosisd background service (recommended)
3) Don't install cosmovisor and don't set up a background service
    """ + bcolors.ENDC)
    if args.cosmovisorService == "cosmoservice":
        useCosmovisor = '1'
    elif args.cosmovisorService == "osmoservice":
        useCosmovisor = '2'
    elif args.cosmovisorService == "noservice":
        useCosmovisor = '3'
    else:
        useCosmovisor = input(
            bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if useCosmovisor == "1":
        subprocess.run(["clear"], shell=True)
        colorprint("Setting Up Cosmovisor...")
        os.chdir(os.path.expanduser(HOME))
        subprocess.run(["go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["mkdir -p "+osmo_home+"/cosmovisor"],
                       shell=True, env=my_env)
        subprocess.run(
            ["mkdir -p "+osmo_home+"/cosmovisor/genesis"], shell=True, env=my_env)
        subprocess.run(
            ["mkdir -p "+osmo_home+"/cosmovisor/genesis/bin"], shell=True, env=my_env)
        subprocess.run(
            ["mkdir -p "+osmo_home+"/cosmovisor/upgrades"], shell=True, env=my_env)
        subprocess.run(
            ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v9/bin"], shell=True, env=my_env)
        os.chdir(os.path.expanduser(HOME+"/osmosis"))
        subprocess.run(["git checkout {v}".format(v=NetworkVersion.MAINNET)],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["make build"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v9/bin"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["cp " + GOPATH + "/bin/osmosisd "+osmo_home +
                       "/cosmovisor/genesis/bin"], shell=True, env=my_env)
        cosmovisorService()
        subprocess.run(["sudo systemctl start cosmovisor"],
                       shell=True, env=my_env)
        subprocess.run(["clear"], shell=True)
        completeCosmovisor()
    elif useCosmovisor == "2":
        osmosisdService()
        subprocess.run(["sudo systemctl start osmosisd"],
                       shell=True, env=my_env)
        subprocess.run(["clear"], shell=True)
        completeOsmosisd()
    elif useCosmovisor == "3":
        subprocess.run(["clear"], shell=True)
        complete()
    else:
        subprocess.run(["clear"], shell=True)
        cosmovisorInit()


def startReplayNow():
    print(bcolors.OKPINK + """Do you want to start cosmovisor as a background service?
1) Yes, start cosmovisor as a background service and begin replay
2) No, exit and start on my own (will still auto update at upgrade heights)
    """ + bcolors.ENDC)
    if args.startReplay == True:
        startNow = '1'
    elif args.startReplay == False:
        startNow = '2'
    else:
        startNow = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if startNow == "1":
        subprocess.run(["clear"], shell=True)
        cosmovisorService()
        subprocess.run(["sudo systemctl start cosmovisor"],
                       shell=True, env=my_env)
        replayComplete()
    if startNow == "2":
        subprocess.run(["echo '# Setup Cosmovisor' >> "+HOME +
                       "/.profile"], shell=True, env=my_env)
        subprocess.run(["echo 'export DAEMON_NAME=osmosisd' >> " +
                       HOME+"/.profile"], shell=True, env=my_env)
        subprocess.run(["echo 'export DAEMON_HOME="+osmo_home +
                       "' >> "+HOME+"/.profile"], shell=True, env=my_env)
        subprocess.run(["echo 'export DAEMON_ALLOW_DOWNLOAD_BINARIES=false' >> " +
                       HOME+"/.profile"], shell=True, env=my_env)
        subprocess.run(["echo 'export DAEMON_LOG_BUFFER_SIZE=512' >> " +
                       HOME+"/.profile"], shell=True, env=my_env)
        subprocess.run(["echo 'export DAEMON_RESTART_AFTER_UPGRADE=true' >> " +
                       HOME+"/.profile"], shell=True, env=my_env)
        subprocess.run(["echo 'export UNSAFE_SKIP_BACKUP=true' >> " +
                       HOME+"/.profile"], shell=True, env=my_env)
        subprocess.run(["clear"], shell=True)
        replayDelay()
    else:
        subprocess.run(["clear"], shell=True)
        startReplayNow()


def replayFromGenesisLevelDb():
    colorprint("Setting Up Cosmovisor...")
    os.chdir(os.path.expanduser(HOME))
    subprocess.run(["go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["mkdir -p "+osmo_home+"/cosmovisor"],
                   shell=True, env=my_env)
    subprocess.run(["mkdir -p "+osmo_home+"/cosmovisor/genesis"],
                   shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/genesis/bin"], shell=True, env=my_env)
    subprocess.run(["mkdir -p "+osmo_home+"/cosmovisor/upgrades"],
                   shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v4/bin"], shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v5/bin"], shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v7/bin"], shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v9/bin"], shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v11/bin"], shell=True, env=my_env)
    os.chdir(os.path.expanduser(HOME+"/osmosis"))
    colorprint("Preparing v4 Upgrade...")
    subprocess.run(["git checkout v4.2.0"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v4/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Preparing v5/v6 Upgrade...")
    subprocess.run(["git checkout v6.4.1"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v5/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Preparing v7/v8 Upgrade...")
    subprocess.run(["git checkout v8.0.0"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v7/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Preparing v9/v10 Upgrade...")
    subprocess.run(["git checkout v10.0.1"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v9/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Preparing v11 Upgrade...")
    subprocess.run(["git checkout {v}".format(v=NetworkVersion.MAINNET)],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v11/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["git checkout v3.1.0"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["make install"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp " + GOPATH + "/bin/osmosisd "+osmo_home +
                   "/cosmovisor/genesis/bin"], shell=True, env=my_env)
    colorprint("Adding Persistent Peers For Replay...")
    peers = "b5ace00790c9cc7990370d7a117ef2a29f19b961@65.109.20.216:26656,2dd86ed01eae5673df4452ce5b0dddb549f46a38@34.66.52.160:26656,2dd86ed01eae5673df4452ce5b0dddb549f46a38@34.82.89.95:26656"
    subprocess.run(["sed -i -E 's/persistent_peers = \"\"/persistent_peers = \"" +
                   peers+"\"/g' "+osmo_home+"/config/config.toml"], shell=True)
    subprocess.run(["clear"], shell=True)
    startReplayNow()


def replayFromGenesisRocksDb():
    colorprint("Changing db_backend to rocksdb...")
    subprocess.run(["sed -i -E 's/db_backend = \"goleveldb\"/db_backend = \"rocksdb\"/g' "+osmo_home +
                   "/config/config.toml"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    colorprint("Installing rocksdb...")
    colorprint("This process may take 15 minutes or more")
    os.chdir(os.path.expanduser(HOME))
    subprocess.run(["sudo apt-get install -y libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    subprocess.run(["git clone https://github.com/facebook/rocksdb.git"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    os.chdir(os.path.expanduser(HOME+"/rocksdb"))
    subprocess.run(["git checkout v6.29.3"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True)
    subprocess.run(["export CXXFLAGS='-Wno-error=deprecated-copy -Wno-error=pessimizing-move -Wno-error=class-memaccess'"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    subprocess.run(["sudo make shared_lib"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True)
    subprocess.run(["sudo make install-shared INSTALL_PATH=/usr"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    subprocess.run(["sudo echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> $HOME/.bashrc"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    my_env["LD_LIBRARY_PATH"] = "/usr/local/lib"
    colorprint("Setting Up Cosmovisor...")
    os.chdir(os.path.expanduser(HOME))
    subprocess.run(["go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["mkdir -p "+osmo_home+"/cosmovisor"],
                   shell=True, env=my_env)
    subprocess.run(["mkdir -p "+osmo_home+"/cosmovisor/genesis"],
                   shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/genesis/bin"], shell=True, env=my_env)
    subprocess.run(["mkdir -p "+osmo_home+"/cosmovisor/upgrades"],
                   shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v4/bin"], shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v5/bin"], shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v7/bin"], shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v9/bin"], shell=True, env=my_env)
    subprocess.run(
        ["mkdir -p "+osmo_home+"/cosmovisor/upgrades/v11/bin"], shell=True, env=my_env)
    os.chdir(os.path.expanduser(HOME+"/osmosis"))
    colorprint("Preparing v4 Upgrade...")
    subprocess.run(["git stash"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["git checkout v4.2.0"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["sed '/gorocksdb.*/d' ./go.mod"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["echo \" \" >> ./go.mod"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["echo 'replace github.com/tecbot/gorocksdb => github.com/cosmos/gorocksdb v1.2.0' >> ./go.mod"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["go mod tidy"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["BUILD_TAGS=rocksdb make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v4/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Preparing v5/v6 Upgrade...")
    subprocess.run(["git stash"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["git checkout v6.4.1"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["BUILD_TAGS=rocksdb make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v5/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Preparing v7/v8 Upgrade...")
    subprocess.run(["git checkout v8.0.0"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["BUILD_TAGS=rocksdb make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v7/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Preparing v9/v10 Upgrade...")
    subprocess.run(["git checkout v10.0.1"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["BUILD_TAGS=rocksdb make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v9/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Preparing v11 Upgrade...")
    subprocess.run(["git checkout {v}".format(v=NetworkVersion.MAINNET)],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["BUILD_TAGS=rocksdb make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/upgrades/v11/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["git stash"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["git checkout v3.1.0"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["sed '/gorocksdb.*/d' ./go.mod"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["echo \" \" >> ./go.mod"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["echo 'require github.com/tecbot/gorocksdb v0.0.0-20191217155057-f0fad39f321c // indirect' >> ./go.mod"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["echo 'replace github.com/tecbot/gorocksdb => github.com/cosmos/gorocksdb v1.2.0' >> ./go.mod"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["go mod tidy"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["BUILD_TAGS=rocksdb make build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["cp build/osmosisd "+osmo_home+"/cosmovisor/genesis/bin"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["BUILD_TAGS=rocksdb make install"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["sudo /sbin/ldconfig -v"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Adding Persistent Peers For Replay...")
    peers = "b5ace00790c9cc7990370d7a117ef2a29f19b961@65.109.20.216:26656,2dd86ed01eae5673df4452ce5b0dddb549f46a38@34.66.52.160:26656,2dd86ed01eae5673df4452ce5b0dddb549f46a38@34.82.89.95:26656"
    subprocess.run(["sed -i -E 's/persistent_peers = \"\"/persistent_peers = \"" +
                   peers+"\"/g' "+osmo_home+"/config/config.toml"], shell=True)
    subprocess.run(["clear"], shell=True)
    startReplayNow()


def replayFromGenesisDb():
    print(bcolors.OKPINK + """Please choose which database you want to use:
1) goleveldb (Default)
2) rocksdb (faster but less support)
    """ + bcolors.ENDC)
    if args.replayDbBackend == "goleveldb":
        databaseType = '1'
    elif args.replayDbBackend == "rocksdb":
        databaseType = '2'
    else:
        databaseType = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if databaseType == "1":
        subprocess.run(["clear"], shell=True)
        replayFromGenesisLevelDb()
    elif databaseType == "2":
        subprocess.run(["clear"], shell=True)
        replayFromGenesisRocksDb()
    else:
        subprocess.run(["clear"], shell=True)
        replayFromGenesisDb()


def extraSwap():
    mem_bytes = os.sysconf('SC_PAGE_SIZE') * os.sysconf('SC_PHYS_PAGES')
    mem_gib = mem_bytes/(1024.**3)
    colorprint("RAM Detected: "+str(round(mem_gib))+"GB")
    swapNeeded = 64 - round(mem_gib)
    if round(mem_gib) < 64:
        colorprint("""
There have been reports of replay from genesis needing extra swap (up to 64GB) to prevent OOM errors.
Would you like to overwrite any previous swap file and instead set a """+str(swapNeeded)+"""GB swap file?
1) Yes, set up extra swap (recommended)
2) No, do not set up extra swap
        """)
        if args.extraSwap == True:
            swapAns = '1'
        elif args.extraSwap == False:
            swapAns = '2'
        else:
            swapAns = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

        if swapAns == "1":
            colorprint("Setting up " + str(swapNeeded) + "GB swap file...")
            subprocess.run(["sudo swapoff -a"], stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["sudo fallocate -l " + str(swapNeeded)+"G /swapfile"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["sudo chmod 600 /swapfile"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["sudo mkswap /swapfile"], stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["sudo swapon /swapfile"], stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["sudo cp /etc/fstab /etc/fstab.bak"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["clear"], shell=True)
            colorprint(str(swapNeeded)+"GB swap file set")
            replayFromGenesisDb()
        elif swapAns == "2":
            subprocess.run(["clear"], shell=True)
            replayFromGenesisDb()
        else:
            subprocess.run(["clear"], shell=True)
            extraSwap()
    else:
        colorprint(
            "You have enough RAM to meet the 64GB minimum requirement, moving on to system setup...")
        time.sleep(3)
        subprocess.run(["clear"], shell=True)
        replayFromGenesisDb()


# def stateSyncInit ():
#     colorprint("Replacing trust height, trust hash, and RPCs in config.toml")
#     LATEST_HEIGHT= subprocess.run(["curl -s http://osmo-sync.blockpane.com:26657/block | jq -r .result.block.header.height"], capture_output=True, shell=True, text=True, env=my_env)
#     TRUST_HEIGHT= str(int(LATEST_HEIGHT.stdout.strip()) - 2000)
#     TRUST_HASH= subprocess.run(["curl -s \"http://osmo-sync.blockpane.com:26657/block?height="+str(TRUST_HEIGHT)+"\" | jq -r .result.block_id.hash"], capture_output=True, shell=True, text=True, env=my_env)
#     RPCs = "osmo-sync.blockpane.com:26657,osmo-sync.blockpane.com:26657"
#     subprocess.run(["sed -i -E 's/enable = false/enable = true/g' "+osmo_home+"/config/config.toml"], shell=True)
#     subprocess.run(["sed -i -E 's/rpc_servers = \"\"/rpc_servers = \""+RPCs+"\"/g' "+osmo_home+"/config/config.toml"], shell=True)
#     subprocess.run(["sed -i -E 's/trust_height = 0/trust_height = "+TRUST_HEIGHT+"/g' "+osmo_home+"/config/config.toml"], shell=True)
#     subprocess.run(["sed -i -E 's/trust_hash = \"\"/trust_hash = \""+TRUST_HASH.stdout.strip()+"\"/g' "+osmo_home+"/config/config.toml"], shell=True)
#     print(bcolors.OKPINK + """
# Osmosis is about to statesync. This process can take anywhere from 5-30 minutes.
# During this process, you will see many logs (to include many errors)
# As long as it continues to find/apply snapshot chunks, it is working.
# If it stops finding/applying snapshot chunks, you may cancel and try a different method.

# Continue?:
# 1) Yes
# 2) No
#     """+ bcolors.ENDC)
#     stateSyncAns = input(bcolors.OKPINK + 'Enter Choice: '+ bcolors.ENDC)
#     if stateSyncAns == "1":
#         subprocess.run(["osmosisd start"], shell=True, env=my_env)
#         colorprint("Statesync finished. Installing required patches for state sync fix")
#         os.chdir(os.path.expanduser(HOME))
#         subprocess.run(["git clone https://github.com/tendermint/tendermint"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
#         os.chdir(os.path.expanduser(HOME+'/tendermint/'))
#         subprocess.run(["git checkout callum/app-version"], shell=True, env=my_env)
#         subprocess.run(["make install"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
#         subprocess.run(["tendermint set-app-version 1 --home "+osmo_home], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
#         subprocess.run(["clear"], shell=True)
#         if os_name == "Linux":
#             cosmovisorInit()
#         else:
#             complete()
#     elif stateSyncAns == "2":
#         dataSyncSelection()
#     else:
#         subprocess.run(["clear"], shell=True)
#         stateSyncInit()

# def testnetStateSyncInit ():
    #colorprint("Replacing trust height, trust hash, and RPCs in config.toml")
    #LATEST_HEIGHT= subprocess.run(["curl -s http://143.198.139.33:26657/block | jq -r .result.block.header.height"], capture_output=True, shell=True, text=True, env=my_env)
    #TRUST_HEIGHT= str(int(LATEST_HEIGHT.stdout.strip()) - 2000)
    #TRUST_HASH= subprocess.run(["curl -s \"http://143.198.139.33:26657/block?height="+str(TRUST_HEIGHT)+"\" | jq -r .result.block_id.hash"], capture_output=True, shell=True, text=True, env=my_env)
    #RPCs = "143.198.139.33:26657,143.198.139.33:26657"
    #subprocess.run(["sed -i -E 's/enable = false/enable = true/g' "+osmo_home+"/config/config.toml"], shell=True)
    #subprocess.run(["sed -i -E 's/rpc_servers = \"\"/rpc_servers = \""+RPCs+"\"/g' "+osmo_home+"/config/config.toml"], shell=True)
    #subprocess.run(["sed -i -E 's/trust_height = 0/trust_height = "+TRUST_HEIGHT+"/g' "+osmo_home+"/config/config.toml"], shell=True)
    #subprocess.run(["sed -i -E 's/trust_hash = \"\"/trust_hash = \""+TRUST_HASH.stdout.strip()+"\"/g' "+osmo_home+"/config/config.toml"], shell=True)
    # if os_name == "Linux":
        #subprocess.run(["clear"], shell=True)
        # cosmovisorInit()
    # else:
        #subprocess.run(["clear"], shell=True)
        # complete()
def infraSnapshotInstall():
    colorprint("Downloading Decompression Packages...")
    if os_name == "Linux":
        subprocess.run(["sudo apt-get install wget liblz4-tool aria2 -y"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    else:
        subprocess.run(["brew install aria2"], shell=True, env=my_env)
        subprocess.run(["brew install lz4"], shell=True, env=my_env)
    colorprint("Downloading Snapshot...")
    proc = subprocess.run(["curl https://osmosis-snapshot.sfo3.cdn.digitaloceanspaces.com/osmosis.json|jq -r '.[] |select(.file==\"osmosis-1-pruned\")|.url'"],
                          capture_output=True, shell=True, text=True)
    os.chdir(os.path.expanduser(osmo_home))
    subprocess.run(["wget -O - "+proc.stdout.strip() +
                   " | lz4 -d | tar -xvf -"], shell=True, env=my_env)
    subprocess.run(["clear"], shell=True)
    if os_name == "Linux":
        cosmovisorInit()
    else:
        complete()


def snapshotInstall():
    colorprint("Downloading Decompression Packages...")
    if os_name == "Linux":
        subprocess.run(["sudo apt-get install wget liblz4-tool aria2 -y"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    else:
        subprocess.run(["brew install aria2"], shell=True, env=my_env)
        subprocess.run(["brew install lz4"], shell=True, env=my_env)
    colorprint("Downloading Snapshot from " + location + " ...")
    proc = subprocess.run(["curl -L https://quicksync.io/osmosis.json|jq -r '.[] |select(.file==\"" + fileName +
                          "\")|select (.mirror==\"" + location + "\")|.url'"], capture_output=True, shell=True, text=True)
    os.chdir(os.path.expanduser(osmo_home))
    subprocess.run(["wget -O - "+proc.stdout.strip() +
                   " | lz4 -d | tar -xvf -"], shell=True, env=my_env)
    subprocess.run(["clear"], shell=True)
    if os_name == "Linux":
        cosmovisorInit()
    else:
        complete()


def mainNetLocation():
    global location
    location_map = {"1": "Netherlands", "2": "Singapore", "3": "SanFrancisco"}
    colorprint("""Please choose the location nearest to your node:
1) Netherlands
2) Singapore
3) SanFrancisco (WARNING: Location usually slow)
    """)
    nodeLocationAns = get_key_case_insensitive(
        location_map, args.snapshotLocation)
    if nodeLocationAns == None:
        nodeLocationAns = input(
            bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    subprocess.run(["clear"], shell=True)
    if nodeLocationAns in location_map:
        location = location_map[nodeLocationAns]
        snapshotInstall()
    else:
        mainNetLocation()


def testNetType():
    global fileName
    global location
    testnet_type_map = {"1": "pruned", "2": "archive"}
    print(bcolors.OKPINK + """Please choose the node snapshot type:
1) Pruned (recommended)
2) Archive
    """ + bcolors.ENDC)
    if args.snapshotTypeTestnet == "pruned":
        nodeTypeAns = "1"
    elif args.snapshotTypeTestnet == "archive":
        nodeTypeAns = "2"
    else:
        nodeTypeAns = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if nodeTypeAns == "1":
        subprocess.run(["clear"], shell=True)
        fileName = "osmotestnet-4-pruned"
        location = "Netherlands"
        snapshotInstall()
    elif nodeTypeAns == "2":
        subprocess.run(["clear"], shell=True)
        fileName = "osmotestnet-4-archive"
        location = "Netherlands"
        snapshotInstall()
    else:
        subprocess.run(["clear"], shell=True)
        testNetType()


def mainNetType():
    global fileName
    global location
    print(bcolors.OKPINK + """Please choose the node snapshot type:
1) Pruned (recommended)
2) Default
3) Archive
    """ + bcolors.ENDC)
    if args.snapshotType == "pruned":
        nodeTypeAns = "1"
    elif args.snapshotType == "default":
        nodeTypeAns = "2"
    elif args.snapshotType == "archive":
        nodeTypeAns = "3"
    elif args.snapshotType == "infra":
        subprocess.run(["clear"], shell=True)
        infraSnapshotInstall()
    else:
        nodeTypeAns = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if nodeTypeAns == "1":
        subprocess.run(["clear"], shell=True)
        fileName = "osmosis-1-pruned"
        mainNetLocation()
    elif nodeTypeAns == "2":
        subprocess.run(["clear"], shell=True)
        fileName = "osmosis-1-default"
        mainNetLocation()
    elif nodeTypeAns == "3":
        subprocess.run(["clear"], shell=True)
        fileName = "osmosis-1-archive"
        location = "Netherlands"
        snapshotInstall()
    else:
        subprocess.run(["clear"], shell=True)
        mainNetType()


def dataSyncSelection():
    print(bcolors.OKPINK + """Please choose from the following options:
1) Download a snapshot from ChainLayer (recommended)
2) Start at block 1 and automatically upgrade at upgrade heights (replay from genesis, can also select rocksdb here)
3) Exit now, I only wanted to install the daemon
    """ + bcolors.ENDC)
    if args.dataSync == "snapshot":
        dataTypeAns = "1"
    elif args.dataSync == "genesis":
        dataTypeAns = "2"
    elif args.dataSync == "exit":
        dataTypeAns = "3"
    else:
        dataTypeAns = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if dataTypeAns == "1":
        subprocess.run(["clear"], shell=True)
        mainNetType()
    elif dataTypeAns == "2":
        subprocess.run(["clear"], shell=True)
        extraSwap()
    # elif dataTypeAns == "2":
        #subprocess.run(["clear"], shell=True)
        #stateSyncInit ()
    elif dataTypeAns == "3":
        subprocess.run(["clear"], shell=True)
        partComplete()
    else:
        subprocess.run(["clear"], shell=True)
        dataSyncSelection()


def dataSyncSelectionTest():
    print(bcolors.OKPINK + """Please choose from the following options:
1) Download a snapshot from ChainLayer (recommended)
2) Exit now, I only wanted to install the daemon
    """ + bcolors.ENDC)
    if args.dataSyncTestnet == "snapshot":
        dataTypeAns = "1"
    elif args.dataSyncTestnet == "exit":
        dataTypeAns = "2"
    else:
        dataTypeAns = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if dataTypeAns == "1":
        subprocess.run(["clear"], shell=True)
        testNetType()
    # elif dataTypeAns == "2":
        #subprocess.run(["clear"], shell=True)
        # testnetStateSyncInit()
    elif dataTypeAns == "2":
        subprocess.run(["clear"], shell=True)
        partComplete()
    else:
        subprocess.run(["clear"], shell=True)
        dataSyncSelectionTest()


def pruningSettings():

    print(bcolors.OKPINK + """Please choose your desired pruning settings:
1) Default: (keep last 100,000 states to query the last week worth of data and prune at 100 block intervals)
2) Nothing: (keep everything, select this if running an archive node)
3) Everything: (modified prune everything due to bug, keep last 10,000 states and prune at a random prime block interval)
    """ + bcolors.ENDC)

    if args.pruning == "default":
        pruneAns = '1'
    elif args.pruning == "nothing":
        pruneAns = '2'
    elif args.pruning == "everything":
        pruneAns = '3'
    else:
        pruneAns = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if pruneAns == "1" and networkType == NetworkType.MAINNET:
        subprocess.run(["clear"], shell=True)
        dataSyncSelection()
    elif pruneAns == "1" and networkType == NetworkType.TESTNET:
        subprocess.run(["clear"], shell=True)
        dataSyncSelectionTest()
    elif pruneAns == "2" and networkType == NetworkType.MAINNET:
        subprocess.run(["clear"], shell=True)
        subprocess.run(["sed -i -E 's/pruning = \"default\"/pruning = \"nothing\"/g' " +
                       osmo_home+"/config/app.toml"], shell=True)
        dataSyncSelection()
    elif pruneAns == "2" and networkType == NetworkType.TESTNET:
        subprocess.run(["clear"], shell=True)
        subprocess.run(["sed -i -E 's/pruning = \"default\"/pruning = \"nothing\"/g' " +
                       osmo_home+"/config/app.toml"], shell=True)
        dataSyncSelectionTest()
    elif pruneAns == "3" and networkType == NetworkType.MAINNET:
        primeNum = random.choice([x for x in range(11, 97) if not [
                                 t for t in range(2, x) if not x % t]])
        subprocess.run(["clear"], shell=True)
        subprocess.run(["sed -i -E 's/pruning = \"default\"/pruning = \"custom\"/g' " +
                       osmo_home+"/config/app.toml"], shell=True)
        subprocess.run(["sed -i -E 's/pruning-keep-recent = \"0\"/pruning-keep-recent = \"10000\"/g' " +
                       osmo_home+"/config/app.toml"], shell=True)
        subprocess.run(["sed -i -E 's/pruning-interval = \"0\"/pruning-interval = \"" +
                       str(primeNum)+"\"/g' "+osmo_home+"/config/app.toml"], shell=True)
        dataSyncSelection()
    elif pruneAns == "3" and networkType == NetworkType.TESTNET:
        primeNum = random.choice([x for x in range(11, 97) if not [
                                 t for t in range(2, x) if not x % t]])
        subprocess.run(["clear"], shell=True)
        subprocess.run(["sed -i -E 's/pruning = \"default\"/pruning = \"custom\"/g' " +
                       osmo_home+"/config/app.toml"], shell=True)
        subprocess.run(["sed -i -E 's/pruning-keep-recent = \"0\"/pruning-keep-recent = \"10000\"/g' " +
                       osmo_home+"/config/app.toml"], shell=True)
        subprocess.run(["sed -i -E 's/pruning-interval = \"0\"/pruning-interval = \"" +
                       str(primeNum)+"\"/g' "+osmo_home+"/config/app.toml"], shell=True)
        dataSyncSelectionTest()
    else:
        subprocess.run(["clear"], shell=True)
        pruningSettings()


def customPortSelection():
    print(bcolors.OKPINK + """Do you want to run Osmosis on default ports?:
1) Yes, use default ports (recommended)
2) No, specify custom ports
    """ + bcolors.ENDC)
    if args.ports:
        api_server = args.ports[0]
        grpc_server = args.ports[1]
        grpc_web = args.ports[2]
        abci_app_addr = args.ports[3]
        rpc_laddr = args.ports[4]
        p2p_laddr = args.ports[5]
        pprof_laddr = args.ports[6]
    else:
        portChoice = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

        if portChoice == "1":
            subprocess.run(["clear"], shell=True)
            pruningSettings()
        elif portChoice == "2":
            subprocess.run(["clear"], shell=True)
            colorprint("Input desired values. Press enter for default values")
            # app.toml
            api_server_def = "tcp://0.0.0.0:1317"
            grpc_server_def = "0.0.0.0:9090"
            grpc_web_def = "0.0.0.0:9091"
            # config.toml
            abci_app_addr_def = "tcp://127.0.0.1:26658"
            rpc_laddr_def = "tcp://127.0.0.1:26657"
            p2p_laddr_def = "tcp://0.0.0.0:26656"
            pprof_laddr_def = "localhost:6060"
            # user input
            api_server = rlinput(
                bcolors.OKPINK + "(1/7) API Server: " + bcolors.ENDC, api_server_def)
            grpc_server = rlinput(
                bcolors.OKPINK + "(2/7) gRPC Server: " + bcolors.ENDC, grpc_server_def)
            grpc_web = rlinput(bcolors.OKPINK +
                               "(3/7) gRPC Web: " + bcolors.ENDC, grpc_web_def)
            abci_app_addr = rlinput(
                bcolors.OKPINK + "(4/7) ABCI Application Address: " + bcolors.ENDC, abci_app_addr_def)
            rpc_laddr = rlinput(
                bcolors.OKPINK + "(5/7) RPC Listening Address: " + bcolors.ENDC, rpc_laddr_def)
            p2p_laddr = rlinput(
                bcolors.OKPINK + "(6/7) P2P Listening Address: " + bcolors.ENDC, p2p_laddr_def)
            pprof_laddr = rlinput(
                bcolors.OKPINK + "(7/7) pprof Listening Address: " + bcolors.ENDC, pprof_laddr_def)
        elif portChoice and portChoice != "1" or portChoice != "2":
            subprocess.run(["clear"], shell=True)
            customPortSelection()

    # change app.toml values
    subprocess.run(["sed -i -E 's|tcp://0.0.0.0:1317|"+api_server +
                   "|g' "+osmo_home+"/config/app.toml"], shell=True)
    subprocess.run(["sed -i -E 's|0.0.0.0:9090|"+grpc_server +
                   "|g' "+osmo_home+"/config/app.toml"], shell=True)
    subprocess.run(["sed -i -E 's|0.0.0.0:9091|"+grpc_web +
                   "|g' "+osmo_home+"/config/app.toml"], shell=True)

    # change config.toml values
    subprocess.run(["sed -i -E 's|tcp://127.0.0.1:26658|"+abci_app_addr +
                   "|g' "+osmo_home+"/config/config.toml"], shell=True)
    subprocess.run(["sed -i -E 's|tcp://127.0.0.1:26657|"+rpc_laddr +
                   "|g' "+osmo_home+"/config/config.toml"], shell=True)
    subprocess.run(["sed -i -E 's|tcp://0.0.0.0:26656|"+p2p_laddr +
                   "|g' "+osmo_home+"/config/config.toml"], shell=True)
    subprocess.run(["sed -i -E 's|localhost:6060|"+pprof_laddr +
                   "|g' "+osmo_home+"/config/config.toml"], shell=True)
    subprocess.run(["clear"], shell=True)

    pruningSettings()


def setupLocalnet():
    global version
    print(bcolors.OKPINK + "Initializing LocalOsmosis " + nodeName + bcolors.ENDC)
    os.chdir(os.path.expanduser(HOME+"/osmosis"))
    print(bcolors.OKPINK +
          "Building LocalOsmosis docker image {v}...".format(v=version) + bcolors.ENDC)
    subprocess.run(["make localnet-build"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True)
    subprocess.run(["clear"], shell=True)
    localOsmosisComplete()


def setupMainnet():
    print(bcolors.OKPINK + "Initializing Osmosis Node " + nodeName + bcolors.ENDC)
    #subprocess.run(["osmosisd unsafe-reset-all"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["rm "+osmo_home+"/config/app.toml"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["rm "+osmo_home+"/config/config.toml"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["rm "+osmo_home+"/config/addrbook.json"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["osmosisd init " + nodeName + " --chain-id=osmo-1 -o --home "+osmo_home],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Downloading and Replacing Genesis...")
    subprocess.run(["wget -O "+osmo_home+"/config/genesis.json https://github.com/osmosis-labs/networks/raw/main/osmosis-1/genesis.json"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Downloading and Replacing Addressbook...")
    subprocess.run(["wget -O "+osmo_home+"/config/addrbook.json https://quicksync.io/addrbook.osmosis.json"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["clear"], shell=True)
    customPortSelection()


def setupTestnet():
    print(bcolors.OKPINK + "Initializing Osmosis Node " + nodeName + bcolors.ENDC)
    #subprocess.run(["osmosisd unsafe-reset-all"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["rm "+osmo_home+"/config/config.toml"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["rm "+osmo_home+"/config/app.toml"], stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["rm "+osmo_home+"/config/addrbook.json"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["osmosisd init " + nodeName + " --chain-id=osmo-test-4 -o --home "+osmo_home],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Downloading and Replacing Genesis...")
    subprocess.run(["wget -O "+osmo_home+"/config/genesis.tar.bz2 wget https://github.com/osmosis-labs/networks/raw/main/osmo-test-4/genesis.tar.bz2"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    colorprint("Finding and Replacing Seeds...")
    peers = "4ab030b7fd75ed895c48bcc899b99c17a396736b@137.184.190.127:26656,3dbffa30baab16cc8597df02945dcee0aa0a4581@143.198.139.33:26656"
    subprocess.run(["sed -i -E 's/persistent_peers = \"\"/persistent_peers = \"" +
                   peers+"\"/g' "+osmo_home+"/config/config.toml"], shell=True)
    subprocess.run(["tar -xjf "+osmo_home+"/config/genesis.tar.bz2"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
    subprocess.run(["rm "+osmo_home+"/config/genesis.tar.bz2"], shell=True)
    subprocess.run(["sed -i -E 's/seeds = \"21d7539792ee2e0d650b199bf742c56ae0cf499e@162.55.132.230:2000,295b417f995073d09ff4c6c141bd138a7f7b5922@65.21.141.212:2000,ec4d3571bf709ab78df61716e47b5ac03d077a1a@65.108.43.26:2000,4cb8e1e089bdf44741b32638591944dc15b7cce3@65.108.73.18:2000,f515a8599b40f0e84dfad935ba414674ab11a668@osmosis.blockpane.com:26656,6bcdbcfd5d2c6ba58460f10dbcfde58278212833@osmosis.artifact-staking.io:26656\"/seeds = \"0f9a9c694c46bd28ad9ad6126e923993fc6c56b1@137.184.181.105:26656\"/g' "+osmo_home+"/config/config.toml"], shell=True)
    colorprint("Downloading and Replacing Addressbook...")
    subprocess.run(["wget -O "+osmo_home+"/config/addrbook.json https://quicksync.io/addrbook.osmotestnet.json"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
    subprocess.run(["clear"], shell=True)
    customPortSelection()


def clientSettings():
    if networkType == NetworkType.MAINNET:
        print(bcolors.OKPINK + "Initializing Osmosis Client Node " +
              nodeName + bcolors.ENDC)
        #subprocess.run(["osmosisd unsafe-reset-all"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["rm "+osmo_home+"/config/client.toml"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["osmosisd init " + nodeName + " --chain-id=osmosis-1 -o --home "+osmo_home],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        colorprint("Changing Client Settings...")
        subprocess.run(["sed -i -E 's/chain-id = \"\"/chain-id = \"osmosis-1\"/g' " +
                       osmo_home+"/config/client.toml"], shell=True)
        #subprocess.run(["sed -i -E 's|node = \"tcp://localhost:26657\"|node = \"https://rpc-osmosis.blockapsis.com:443\"|g' "+osmo_home+"/config/client.toml"], shell=True)
        subprocess.run(["sed -i -E 's|node = \"tcp://localhost:26657\"|node = \"http://osmosis.artifact-staking.io:26657\"|g' " +
                       osmo_home+"/config/client.toml"], shell=True)
        subprocess.run(["clear"], shell=True)
        clientComplete()

    elif networkType == NetworkType.TESTNET:
        print(bcolors.OKPINK + "Initializing Osmosis Client Node " +
              nodeName + bcolors.ENDC)
        #subprocess.run(["osmosisd unsafe-reset-all"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["rm "+osmo_home+"/config/client.toml"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["osmosisd init " + nodeName + " --chain-id=osmo-test-4 -o --home "+osmo_home],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        colorprint("Changing Client Settings...")
        subprocess.run(["sed -i -E 's/chain-id = \"\"/chain-id = \"osmo-test-4\"/g' " +
                       osmo_home+"/config/client.toml"], shell=True)
        subprocess.run(["sed -i -E 's|node = \"tcp://localhost:26657\"|node = \"https://rpc.testnet.osmosis.zone:443\"|g' " +
                       osmo_home+"/config/client.toml"], shell=True)
        subprocess.run(["clear"], shell=True)
        clientComplete()

    elif networkType == NetworkType.LOCALOSMOSIS:
        print(bcolors.OKPINK + "Initializing LocalOsmosis Node " +
              nodeName + bcolors.ENDC)
        subprocess.run(["rm "+osmo_home+"/config/client.toml"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["osmosisd init " + nodeName + " --chain-id=localosmosis -o --home "+osmo_home],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True, env=my_env)
        colorprint("Changing Client Settings...")
        subprocess.run(["sed -i -E 's/chain-id = \"\"/chain-id = \"localosmosis\"/g' " +
                       osmo_home+"/config/client.toml"], shell=True)
        subprocess.run(["sed -i -E 's|node = \"tcp://localhost:26657\"|node = \"tcp://127.0.0.1:26657\"|g' " +
                       osmo_home+"/config/client.toml"], shell=True)
        subprocess.run(["clear"], shell=True)
        setupLocalnet()


def initNodeName():
    global nodeName
    colorprint(
        "AFTER INPUTTING NODE NAME, ALL PREVIOUS OSMOSIS DATA WILL BE RESET")

    if args.nodeName:
        nodeName = args.nodeName
    else:
        nodeName = input(
            bcolors.OKPINK + "Input desired node name (no quotes, cant be blank): " + bcolors.ENDC)

    if nodeName and networkType == NetworkType.MAINNET and node == NodeType.FULL:
        subprocess.run(["clear"], shell=True)
        subprocess.run(["rm -r "+osmo_home], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["rm -r "+HOME+"/.osmosisd"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True, env=my_env)
        setupMainnet()
    elif nodeName and networkType == NetworkType.TESTNET and node == NodeType.FULL:
        subprocess.run(["clear"], shell=True)
        subprocess.run(["rm -r "+osmo_home], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["rm -r "+HOME+"/.osmosisd"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True, env=my_env)
        setupTestnet()
    elif nodeName and node == NodeType.CLIENT or node == NodeType.LOCALOSMOSIS:
        subprocess.run(["clear"], shell=True)
        subprocess.run(["rm -r "+osmo_home], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True, env=my_env)
        subprocess.run(["rm -r "+HOME+"/.osmosisd"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True, env=my_env)
        clientSettings()
    else:
        subprocess.run(["clear"], shell=True)
        colorprint("Please insert a non-blank node name")
        initNodeName()


def installLocationHandler():
    global osmo_home
    colorprint(
        "Input desired installation location. Press enter for default location")
    location_def = subprocess.run(
        ["echo $HOME/.osmosisd"], capture_output=True, shell=True, text=True).stdout.strip()

    if args.installHome:
        osmo_home = args.installHome
    else:
        osmo_home = rlinput(
            bcolors.OKPINK + "Installation Location: " + bcolors.ENDC, location_def)

    if osmo_home.endswith("/"):
        print(bcolors.FAIL +
              "Please ensure your path does not end with `/`" + bcolors.FAIL)
        installLocationHandler()
    elif not osmo_home.startswith("/") and not osmo_home.startswith("$"):
        print(bcolors.FAIL + "Please ensure your path begin with a `/`" + bcolors.FAIL)
        installLocationHandler()
    elif osmo_home == "":
        print(bcolors.FAIL + "Please ensure your path is not blank" + bcolors.FAIL)
        installLocationHandler()
    else:
        osmo_home = subprocess.run(
            ["echo "+osmo_home], capture_output=True, shell=True, text=True).stdout.strip()
        subprocess.run(["clear"], shell=True)
        initNodeName()


def installLocation():
    global osmo_home
    print(bcolors.OKPINK + """Do you want to install Osmosis in the default location?:
1) Yes, use default location (recommended)
2) No, specify custom location
    """ + bcolors.ENDC)

    if args.installHome:
        locationChoice = '2'
    else:
        locationChoice = input(
            bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if locationChoice == "1":
        subprocess.run(["clear"], shell=True)
        osmo_home = subprocess.run(
            ["echo $HOME/.osmosisd"], capture_output=True, shell=True, text=True).stdout.strip()
        initNodeName()
    elif locationChoice == "2":
        subprocess.run(["clear"], shell=True)
        installLocationHandler()
    else:
        subprocess.run(["clear"], shell=True)
        installLocation()


def setupContactEnvironment():
    my_env = os.environ.copy()
    my_env["PATH"] = "/"+HOME+"/go/bin:/"+HOME+"/go/bin:/" + \
        HOME+"/.go/bin:"+HOME+"/.cargo/bin:" + my_env["PATH"]
    print(bcolors.OKPINK + """Do you want to set up a basic contract environment?:
1) Yes, setup a basic contract environment
2) No, continue with the rest of the setup
    """ + bcolors.ENDC)

    setupContractEnv = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if setupContractEnv == "1":
        subprocess.run(["clear"], shell=True)
        colorprint("Setting 'stable' as the default release channel:")
        subprocess.run(["rustup default stable"], shell=True, env=my_env)
        colorprint("Adding WASM as the compilation target:")
        subprocess.run(
            ["rustup target add wasm32-unknown-unknown"], shell=True, env=my_env)
        colorprint("Installing packages to generate the contract:")
        subprocess.run(
            ["cargo install cargo-generate --features vendored-openssl"], shell=True, env=my_env)
        subprocess.run(["cargo install cargo-run-script"],
                       shell=True, env=my_env)
        colorprint("Installing beaker:")
        subprocess.run(["cargo install -f beaker"], shell=True, env=my_env)
    elif setupContractEnv == "2":
        subprocess.run(["clear"], shell=True)
    else:
        subprocess.run(["clear"], shell=True)
        setupContactEnvironment()


def installRust():
    isRustInstalled = subprocess.run(
        ["rustc --version"], capture_output=True, shell=True, text=True).stderr.strip()
    if "not found" not in isRustInstalled:
        return
    print(bcolors.OKPINK + """Rust not found on your device. Do you want to install Rust?:
1) Yes, install Rust
2) No, do not install Rust
    """ + bcolors.ENDC)

    installRust = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if installRust == "1":
        subprocess.run(["clear"], shell=True)
        subprocess.run(
            ["curl https://sh.rustup.rs -sSf | sh -s -- -y"], shell=True)
    elif installRust == "2":
        subprocess.run(["clear"], shell=True)
    else:
        subprocess.run(["clear"], shell=True)
        installRust()


def initSetup():
    global my_env
    global repo
    global version

    if os_name == "Linux":
        colorprint("Please wait while the following processes run:")
        colorprint("(1/4) Updating Packages...")
        subprocess.run(["sudo apt-get update"],
                       stdout=subprocess.DEVNULL, shell=True)
        subprocess.run(["DEBIAN_FRONTEND=noninteractive apt-get -y upgrade"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        colorprint("(2/4) Installing make and GCC...")
        subprocess.run(["sudo apt install git build-essential ufw curl jq snapd --yes"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        colorprint("(3/4) Installing Go...")
        subprocess.run(["wget -q -O - https://git.io/vQhTU | bash -s -- --remove"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        subprocess.run(["wget -q -O - https://git.io/vQhTU | bash -s -- --version 1.19"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        os.chdir(os.path.expanduser(HOME))
        gitClone = subprocess.Popen(
            ["git clone "+repo], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, shell=True)
        if "Repository not found" in gitClone.communicate()[1]:
            subprocess.run(["clear"], shell=True)
            print(bcolors.OKPINK + repo + """ repo provided by user does not exist, try another URL
            """ + bcolors.ENDC)
            brachSelection()
        os.chdir(os.path.expanduser(HOME+"/osmosis"))
        subprocess.run(["git stash"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True)
        subprocess.run(["git pull"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True)

        print(bcolors.OKPINK +
              "(4/4) Installing Osmosis {v} Binary...".format(v=version) + bcolors.ENDC)
        gitCheckout = subprocess.Popen(["git checkout {v}".format(
            v=version)], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, shell=True)
        if "did not match any file(s) known to git" in gitCheckout.communicate()[1]:
            subprocess.run(["clear"], shell=True)
            print(bcolors.OKPINK + version + """ branch provided by user does not exist, try another branch
            """ + bcolors.ENDC)
            brachSelection()

        my_env = os.environ.copy()
        my_env["PATH"] = "/"+HOME+"/go/bin:/"+HOME + \
            "/go/bin:/"+HOME+"/.go/bin:" + my_env["PATH"]
        subprocess.run(["make install"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True, env=my_env)

        if node == NodeType.LOCALOSMOSIS:
            subprocess.run(["clear"], shell=True)
            colorprint("Installing Docker...")
            subprocess.run(["sudo apt-get remove docker docker-engine docker.io"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["sudo apt-get update"], stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["sudo apt install docker.io -y"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
            colorprint("Installing Docker-Compose...")
            subprocess.run(["sudo apt install docker-compose -y"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
            colorprint("Adding Wallet Keys to Keyring...")
            subprocess.run(["make localnet-keys"], stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["clear"], shell=True)
            installRust()
            subprocess.run(["clear"], shell=True)
            setupContactEnvironment()
        subprocess.run(["clear"], shell=True)

    elif os_name == "Darwin":
        colorprint("Please wait while the following processes run:")
        colorprint(
            "(1/4) Checking for brew and wget. If not present, installing...")
        subprocess.run(["sudo chown -R $(whoami) /usr/local/var/homebrew"],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        subprocess.run(["echo | /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\""],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        subprocess.run(["echo 'eval \"$(/opt/homebrew/bin/brew shellenv)\"' >> "+HOME +
                       "/.zprofile"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        subprocess.run(["eval \"$(/opt/homebrew/bin/brew shellenv)\""],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
        my_env = os.environ.copy()
        my_env["PATH"] = "/opt/homebrew/bin:/opt/homebrew/bin/brew:" + \
            my_env["PATH"]
        subprocess.run(["brew install wget"], shell=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, env=my_env)
        colorprint("(2/4) Checking/installing jq...")
        subprocess.run(["brew install jq"], shell=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, env=my_env)
        colorprint("(3/4) Checking/installing Go...")
        subprocess.run(["brew install coreutils"], shell=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, env=my_env)
        subprocess.run(["asdf plugin-add golang https://github.com/kennyp/asdf-golang.git"],
                       shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, env=my_env)
        subprocess.run(["asdf install golang 1.19"], shell=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, env=my_env)
        os.chdir(os.path.expanduser(HOME))
        gitClone = subprocess.Popen(
            ["git clone "+repo], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, shell=True)
        if "Repository not found" in gitClone.communicate()[1]:
            subprocess.run(["clear"], shell=True)
            print(bcolors.OKPINK + repo + """ repo provided by user does not exist, try another URL
            """ + bcolors.ENDC)
            brachSelection()
        os.chdir(os.path.expanduser(HOME+"/osmosis"))
        subprocess.run(["git stash"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True)
        subprocess.run(["git pull"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL, shell=True)

        print(bcolors.OKPINK +
              "(4/4) Installing Osmosis {v} Binary...".format(v=version) + bcolors.ENDC)
        gitCheckout = subprocess.Popen(["git checkout {v}".format(
            v=version)], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, shell=True)
        if "did not match any file(s) known to git" in gitCheckout.communicate()[1]:
            subprocess.run(["clear"], shell=True)
            print(bcolors.OKPINK + version + """ branch provided by user does not exist, try another branch
            """ + bcolors.ENDC)
            brachSelection()

        my_env["PATH"] = "/"+HOME+"/go/bin:/"+HOME + \
            "/go/bin:/"+HOME+"/.go/bin:" + my_env["PATH"]
        subprocess.run(["make install"], shell=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, env=my_env)

        if node == NodeType.LOCALOSMOSIS:
            subprocess.run(["clear"], shell=True)
            colorprint("Installing Docker...")
            subprocess.run(["brew install docker"], stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL, shell=True)
            colorprint("Installing Docker-Compose...")
            subprocess.run(["brew install docker-compose"],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
            colorprint("Adding Wallet Keys to Keyring...")
            subprocess.run(["make localnet-keys"], stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL, shell=True)
            subprocess.run(["clear"], shell=True)
            installRust()
            subprocess.run(["clear"], shell=True)
            setupContactEnvironment()
        subprocess.run(["clear"], shell=True)
    installLocation()


def branchHandler():
    global version
    colorprint("Input desired branch. Press enter for default branch")
    branch_def = subprocess.run(["echo {v}".format(
        v=version)], capture_output=True, shell=True, text=True).stdout.strip()

    version = rlinput(bcolors.OKPINK + "Branch: " + bcolors.ENDC, branch_def)

    if version == "":
        print(bcolors.FAIL + "Please ensure your branch is not blank" + bcolors.FAIL)
        branchHandler()
    else:
        version = subprocess.run(
            ["echo "+version], capture_output=True, shell=True, text=True).stdout.strip()
        subprocess.run(["clear"], shell=True)
        initSetup()


def repoHandler():
    global repo
    colorprint(
        "Input desired repo URL (do not include branch). Press enter for default location")
    repo_def = subprocess.run(
        ["echo "+repo], capture_output=True, shell=True, text=True).stdout.strip()

    repo = rlinput(bcolors.OKPINK + "Repo URL: " + bcolors.ENDC, repo_def)

    if repo.endswith("/"):
        print(bcolors.FAIL +
              "Please ensure your path does not end with `/`" + bcolors.FAIL)
        repoHandler()
    elif not repo.startswith("https://"):
        print(bcolors.FAIL +
              "Please ensure your path begins with a `https://`" + bcolors.FAIL)
        repoHandler()
    elif repo == "":
        print(bcolors.FAIL + "Please ensure your path is not blank" + bcolors.FAIL)
        repoHandler()
    else:
        repo = subprocess.run(
            ["echo "+repo], capture_output=True, shell=True, text=True).stdout.strip()
        subprocess.run(["clear"], shell=True)
        branchHandler()


def brachSelection():
    global version
    global repo
    repo = "https://github.com/osmosis-labs/osmosis"
    version = NetworkVersion.LOCALOSMOSIS.value
    print(bcolors.OKPINK + """
Would you like to run LocalOsmosis on the most recent release of Osmosis: {v} ?
1) Yes, use {v} (recommended)
2) No, I want to use a different version of Osmosis for LocalOsmosis from a branch on the osmosis repo
3) No, I want to use a different version of Osmosis for LocalOsmosis from a branch on an external repo
    """.format(
        v=version) + bcolors.ENDC)

    branchSelect = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if branchSelect == "1":
        subprocess.run(["clear"], shell=True)
        initSetup()
    elif branchSelect == "2":
        subprocess.run(["clear"], shell=True)
        branchHandler()
    elif branchSelect == "3":
        subprocess.run(["clear"], shell=True)
        repoHandler()
    else:
        subprocess.run(["clear"], shell=True)
        brachSelection()


def initEnvironment():
    global repo
    global version
    repo = "https://github.com/osmosis-labs/osmosis"
    if networkType == NetworkType.MAINNET:
        version = NetworkVersion.MAINNET.value
    if networkType == NetworkType.TESTNET:
        version = NetworkVersion.TESTNET.value

    if os_name == "Linux":
        print(bcolors.OKPINK + "System Detected: Linux" + bcolors.ENDC)
        mem_bytes = os.sysconf('SC_PAGE_SIZE') * os.sysconf('SC_PHYS_PAGES')
        mem_gib = mem_bytes/(1024.**3)
        print(bcolors.OKPINK + "RAM Detected: " +
              str(round(mem_gib))+"GB" + bcolors.ENDC)
        if round(mem_gib) < 32:
            print(bcolors.OKPINK + """
You have less than the recommended 32GB of RAM. Would you like to set up a swap file?
1) Yes, set up swap file
2) No, do not set up swap file
            """ + bcolors.ENDC)
            if args.swapOn == True:
                swapAns = '1'
            elif args.swapOn == False:
                swapAns = '2'
            else:
                swapAns = input(bcolors.OKPINK +
                                'Enter Choice: ' + bcolors.ENDC)

            if swapAns == "1":
                swapNeeded = 32 - round(mem_gib)
                print(bcolors.OKPINK + "Setting up " +
                      str(swapNeeded) + "GB swap file..." + bcolors.ENDC)
                subprocess.run(["sudo swapoff -a"], stdout=subprocess.DEVNULL,
                               stderr=subprocess.DEVNULL, shell=True)
                subprocess.run(["sudo fallocate -l " + str(swapNeeded)+"G /swapfile"],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
                subprocess.run(["sudo chmod 600 /swapfile"],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
                subprocess.run(["sudo mkswap /swapfile"], stdout=subprocess.DEVNULL,
                               stderr=subprocess.DEVNULL, shell=True)
                subprocess.run(["sudo swapon /swapfile"], stdout=subprocess.DEVNULL,
                               stderr=subprocess.DEVNULL, shell=True)
                subprocess.run(["sudo cp /etc/fstab /etc/fstab.bak"],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
                subprocess.run(["echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab"],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, shell=True)
                subprocess.run(["clear"], shell=True)
                print(bcolors.OKPINK + str(swapNeeded) +
                      "GB swap file set" + bcolors.ENDC)
                initSetup()
            elif swapAns == "2":
                subprocess.run(["clear"], shell=True)
                initSetup()
            else:
                subprocess.run(["clear"], shell=True)
                initEnvironment()
        else:
            print(bcolors.OKPINK + "You have enough RAM to meet the 32GB minimum requirement, moving on to system setup..." + bcolors.ENDC)
            time.sleep(3)
            subprocess.run(["clear"], shell=True)
            initSetup()

    elif os_name == "Darwin":
        print(bcolors.OKPINK + "System Detected: Mac" + bcolors.ENDC)
        mem_bytes = subprocess.run(
            ["sysctl hw.memsize"], capture_output=True, shell=True, text=True)
        mem_bytes = str(mem_bytes.stdout.strip())
        mem_bytes = mem_bytes[11:]
        mem_gib = int(mem_bytes)/(1024.**3)
        print(bcolors.OKPINK + "RAM Detected: " +
              str(round(mem_gib))+"GB" + bcolors.ENDC)
        if round(mem_gib) < 32:
            print(bcolors.OKPINK + """
You have less than the recommended 32GB of RAM. Would you still like to continue?
1) Yes, continue
2) No, quit
            """ + bcolors.ENDC)
            if args.swapOn == True:
                warnAns = '1'
            elif args.swapOn == False:
                warnAns = '1'
            else:
                warnAns = input(bcolors.OKPINK +
                                'Enter Choice: ' + bcolors.ENDC)

            if warnAns == "1":
                subprocess.run(["clear"], shell=True)
                initSetup()
            elif warnAns == "2":
                subprocess.run(["clear"], shell=True)
                quit()
            else:
                subprocess.run(["clear"], shell=True)
                initEnvironment()
        else:
            print(bcolors.OKPINK + "You have enough RAM to meet the 32GB minimum requirement, moving on to system setup..." + bcolors.ENDC)
            time.sleep(3)
            subprocess.run(["clear"], shell=True)
            initSetup()
    else:
        print(bcolors.OKPINK + "System OS not detected...Will continue with Linux environment assumption..." + bcolors.ENDC)
        time.sleep(3)
        initSetup()


def selectNetwork():
    global networkType
    global version
    print(bcolors.OKPINK +
          """
Please choose a network to join:
1) Mainnet (osmosis-1)
2) Testnet (osmo-test-4)
    """ + bcolors.ENDC)

    if args.network == "osmosis-1":
        networkType = NetworkType.MAINNET
    elif args.network == "osmo-test-4":
        networkType = NetworkType.TESTNET
    else:
        networkType = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

    if networkType == NetworkType.MAINNET and node == NodeType.FULL:
        subprocess.run(["clear"], shell=True)
        version = NetworkVersion.MAINNET
        initEnvironment()
    elif networkType == NetworkType.MAINNET and node == NodeType.CLIENT:
        subprocess.run(["clear"], shell=True)
        version = NetworkVersion.MAINNET
        initSetup()
    elif networkType == NetworkType.TESTNET and node == NodeType.FULL:
        subprocess.run(["clear"], shell=True)
        version = NetworkVersion.TESTNET
        initEnvironment()
    elif networkType == NetworkType.TESTNET and node == NodeType.CLIENT:
        subprocess.run(["clear"], shell=True)
        version = NetworkVersion.TESTNET
        initSetup()
    else:
        subprocess.run(["clear"], shell=True)
        selectNetwork()


def start():
    subprocess.run(["clear"], shell=True)

    def restart():
        global HOME
        global USER
        global GOPATH
        global machine
        global os_name
        global node
        global networkType
        os_name = platform.system()
        machine = platform.machine()
        HOME = subprocess.run(
            ["echo $HOME"], capture_output=True, shell=True, text=True).stdout.strip()
        USER = subprocess.run(
            ["echo $USER"], capture_output=True, shell=True, text=True).stdout.strip()
        GOPATH = HOME+"/go"
        print(bcolors.OKPINK + """

███╗   ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗
████╗  ██║██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║
██╔██╗ ██║██║   ██║██║  ██║█████╗   ╚███╔╝     ██║     ███████║██████╔╝██║   ██║   ███████║██║
██║╚██╗██║██║   ██║██║  ██║██╔══╝   ██╔██╗     ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║
██║ ╚████║╚██████╔╝██████╔╝███████╗██╔╝ ██╗    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗
╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝

Welcome to the Osmosis node installer!

Mainnet version: {m}
Testnet version: {t}

For more information, please visit docs.osmosis.zone
Ensure no osmosis services are running in the background
If running over an old osmosis installation, back up
any important osmosis data before proceeding

Please choose a node type:
1) Full Node (download chain data and run locally)
2) Client Node (setup a daemon and query a public RPC)
3) LocalOsmosis Node (setup a daemon and query a localOsmosis development RPC)
        """.format(
            m=NetworkVersion.MAINNET.value,
            t=NetworkVersion.TESTNET.value) + bcolors.ENDC)

        if args.nodeType == 'full':
            node = NodeType.FULL
        elif args.nodeType == 'client':
            node = NodeType.CLIENT
        elif args.nodeType == 'local':
            node = NodeType.LOCALOSMOSIS
        else:
            node = input(bcolors.OKPINK + 'Enter Choice: ' + bcolors.ENDC)

        if node == NodeType.FULL:
            subprocess.run(["clear"], shell=True)
            selectNetwork()
        elif node == NodeType.CLIENT:
            subprocess.run(["clear"], shell=True)
            selectNetwork()
        elif node == NodeType.LOCALOSMOSIS:
            networkType = NetworkType.LOCALOSMOSIS
            subprocess.run(["clear"], shell=True)
            brachSelection()
        else:
            subprocess.run(["clear"], shell=True)
            restart()
    restart()


start()