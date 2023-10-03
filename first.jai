#run build();


build :: () {
        w := compiler_create_workspace("quartzz release");
        options := get_build_options();

        imp:[..] string;
        array_add(*imp,"modules");
        array_add(*imp, ..options.import_path);

        options.import_path = imp;
        options.output_executable_name = "quartzz";
        set_optimization(*options, .VERY_OPTIMIZED);
        set_build_options_dc(.{do_output=false});

        set_build_options(*options,w);
        add_build_file("quartzz.jai",w);
        
}

#import "Basic";
#import "Compiler";