Packmule
========

Packmule makes packaging projects easy, like really easy.

Setting up Packmule
-------------------

Setting up Packmule is easy, all you need to do is install the gem: `gem install packmule`.

Now create a file called `Packfile` in your projects directory and place the following inside it:

    package-as: MyProject
    formats:
      - zip
      - tar.gz
    ignore:
      - .DS_Store
      - badfile.bad
      - logs/
      - assets/*.psd
    commands:
      - date > build-date.txt

Now all you need to do is run `packmule pack --version 1.0` inside the directory and your
your project is packaged into `MyProject-1.0.zip` and `MyProject-1.0.tar.gz`.

The Packfile
------------

The `Packfile` is a YAML file and contains the config options for Packmule when packaging the directory.

Packmule supports the following archive formats:

- zip
- tar
- tar.gz
- tar.bz2