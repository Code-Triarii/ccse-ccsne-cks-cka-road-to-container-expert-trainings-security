import docker
import argparse
import sys

client = docker.from_env()

def list_images(args):
    for image in client.images.list():
        print(image.id)

def list_containers(args):
    for container in client.containers.list(all=True):
        print(f"{container.id} {container.status}")

def run_container(args):
    environment = dict(item.split("=") for item in args.env.split(",")) if args.env else None
    volume_dict = dict(map(lambda x: x.split(":"), args.volume.split(","))) if args.volume else None
    port_bindings = {k: v for k, v in (p.split(':') for p in args.ports.split(','))} if args.ports else None

    container = client.containers.run(args.image,
                                      name=args.name,
                                      environment=environment,
                                      volumes=volume_dict,
                                      entrypoint=args.entrypoint,
                                      command=args.command,
                                      ports=port_bindings,
                                      detach=True)
    print(f"Container {container.id} started.")

parser = argparse.ArgumentParser(description="Docker Management Script")
subparsers = parser.add_subparsers()

parser_images = subparsers.add_parser('list-images', help='List all Docker images')
parser_images.set_defaults(func=list_images)

parser_containers = subparsers.add_parser('list-containers', help='List all Docker containers')
parser_containers.set_defaults(func=list_containers)

parser_run = subparsers.add_parser('run', help='Run a Docker container')
parser_run.add_argument("--image", help="Image for running a container", required=True)
parser_run.add_argument("--name", help="Name of the container", required=True)
parser_run.add_argument("--env", help="Comma-separated list of environment variables (e.g., VAR1=value1,VAR2=value2)")
parser_run.add_argument("--volume", help="Comma-separated list of volumes to mount (e.g., /host/path:/container/path)")
parser_run.add_argument("--entrypoint", help="Override the default ENTRYPOINT of the image")
parser_run.add_argument("--command", help="Command to run in the container")
parser_run.add_argument("--ports", help="Comma-separated list of port mappings (e.g., 80:8000,443:8443)")
parser_run.set_defaults(func=run_container)

args = parser.parse_args()

# Check if a command was provided
if 'func' not in args:
    parser.print_help()
    sys.exit(1)

args.func(args)
