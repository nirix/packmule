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
    ignore:
      - badfile.bad
      - logs/
      - assets/*.psd

Now all you need to do is run `packmule pack --version 1.0` inside the directory and your
your project is packaged.

The Packfile
------------

The `Packfile` a YAML file and contains the config options for Packmule when packaging the directory.

Currently only Zip archives are supported.