{
  replacePlaceholders =
    replacements: text:
    builtins.foldl' (
      acc: name:
      builtins.replaceStrings [ name ] [ replacements.${name} ] acc
    ) text (builtins.attrNames replacements);
}
