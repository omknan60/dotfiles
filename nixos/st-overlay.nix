(self: super: {
  st = super.st.overrideAttrs (oldAttrs: {
    pname = "st-om";
    version = "1.0.0";
    src = fetchTarball {
        url = "https://github.com/klorophatu/st/archive/master.tar.gz";
    };
    buildInputs = oldAttrs.buildInputs ++ (with super; [ harfbuzz ]);
  });
})
