shellquizz
==========

Read Me
-------

**1. About**

`shellquizz` is a Zenity based quizz made with shellscript. It supports Zenity version 3.4.0 and bash 4.2.25(1)-release.

**2. Developer Information**

This project was developed by Paulo Henrique Ortolan (paulo.ortolan `at` gmail.com). He is a Java developer in Brazil, but he also develops in other languages as Haskell, Scala and Shellscript just for fun.

Access his page on [github](https://github.com/ortolanph) for more information.

He also has [a blog about Java](http://javalotofbeans.blogspot.com.br/) that he also uses to other languages as cited before.

**3. Instructions**

To start the fun, first you have to start the main script from a shell as shown below:

`./shellquizz.sh`

Sometimes you can have the following error:

`bash: ./shellquizz.sh: Permission denied`

There are two ways to allow the execution of the script

   1. by typing: `chmod +x shellquizz.sh` on a Terminal window
   2. by clicking on the option **Allow executing the file as a program** checkbox on the **Permissions** tab of the properties of the file.

**It will not harm your computer anyway. It will just alter the script file to be treated as a program. After doing this is just execute as shown above.**

**4. Known Bugs**

These are the bugs that are known to the development team:

   1. Questions should not cointain " ". Use "_" instead.

**5. Skipping this screen**

To disable this screen, edit the configuration file `shellquizz.conf` and modify the variable `readme` to `0`.

Thanks for using shellquiz! Have fun!