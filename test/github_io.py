import requests

from octodns.provider.yaml import YamlProvider
from octodns.manager import Manager
from octodns.zone import Zone
from octodns.record import CnameRecord

def validate_github_pages_site(record):
    url = "https://{}".format(record.fqdn[0:-1])
    print "Testing {}".format(url)
    resp = requests.get(url)
    if resp.status_code != 200:
        raise Exception("Got an unexpected status code {}: {}".format(resp.status_code, url))

def main(config_file):
    manager = Manager(config_file)

    for zone_name, config in manager.config['zones'].items():
        zone = Zone(zone_name, manager.configured_sub_zones(zone_name))

        try:
            sources = config['sources']
        except KeyError:
            raise Exception('Zone {} is missing sources'.format(zone_name))

        try:
            sources = [manager.providers[source] for source in sources]
        except KeyError:
            raise Exception('Zone {}, unknown source: {}'.format(zone_name,
                                                                     source))

        for source in sources:
            if isinstance(source, YamlProvider):
                source.populate(zone)

        pages_sites = [record for record in zone.records if isinstance(record, CnameRecord) and record.value.endswith("github.io.")]
        for record in pages_sites:
            validate_github_pages_site(record)

config_file = "config/test.yaml"
main(config_file)