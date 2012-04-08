PackMule
========

PackMule makes packaging projects easy, like really easy.

Setting up PackMule
-------------------

Setting up PackMule is easy, all you need to do is install the gem: `gem install packmule`.

Now create a file called `PackMule` in your projects directory and place the following inside it:

    package-as: MyProject
    format: zip
    ignore:
      - badfile.bad

The PackMule File
-----------------

Currently the PackMule file only supports building zip archives and ignore absolute paths,
however this will change in future versions to allow for ignoring with wildcard paths and directories.