#!/bin/bash
# echo "Setting up environment"
# echo "----------------------"

# virtualenv venv
# source venv/bin/activate

echo "Detecting OS"
dist=`lsb_release -si`
if [ "$(lsb_release -si)" == "Ubuntu" ]; then
    echo "UBUNTU DETECTED"
    echo ""
    echo "Installing exiftool"
    echo "-------------------"
    mkdir deps
    cd deps
    wget "https://exiftool.org/Image-ExifTool-12.39.tar.gz"
    gzip -dc Image-ExifTool-12.39.tar.gz | tar -xf -
    cd Image-ExifTool-12.39
    sudo apt-get install -y perl
    perl Makefile.PL
    make test
    sudo make install
    cd ..

    echo ""
    echo "Installing YARA"
    echo "---------------"
    sudo apt-get install -y automake libtool make gcc pkg-config
    wget "https://github.com/VirusTotal/yara/archive/refs/tags/v4.1.3.tar.gz"
    tar -zxf v4.1.3.tar.gz
    cd yara-4.1.3
    ./bootstrap.sh
    ./configure
    make
    sudo make install
    cd ..
    pip3 install yara-python

    echo ""
    echo "Installing 7ZIP and UPX"
    echo "-----------------------"
    sudo apt-get install -y p7zip-full p7zip-rar
    sudo apt-get install -y upx


    echo ""
    echo "Installing telfhash"
    echo "-----------------------"
    wget https://github.com/trendmicro/tlsh/archive/master.zip -O master.zip
    unzip master.zip
    cd tlsh-master
    make.sh
    cd ..
    git clone https://github.com/trendmicro/telfhash.git
    cd telfhash
    python3 setup.py build
    python3 setup.py install
    cd ..

    echo ""
    echo "Installing python packages"
    echo "--------------------------"
    pip3 install wheel
    pip3 install cffi
    sudo apt-get install -y libarchive-dev
    pip3 install -r requirements.txt 
else
    echo "CENTOS DETECTED"
    echo ""
    echo "Installing exiftool"
    echo "-------------------"
    mkdir deps
    cd deps
    wget "https://exiftool.org/Image-ExifTool-12.39.tar.gz"
    gzip -dc Image-ExifTool-12.39.tar.gz | tar -xf -
    cd Image-ExifTool-12.39
    sudo yum install -y perl-devel
    perl Makefile.PL
    make test
    sudo make install
    cd ..

    echo ""
    echo "Installing YARA"
    echo "---------------"
    sudo yum install -y epel-release autoconf libtool openssl-devel file-devel jansson jansson-devel
    wget "https://github.com/VirusTotal/yara/archive/refs/tags/v4.1.3.tar.gz"
    tar -zxf v4.1.3.tar.gz
    cd yara-4.1.3
    ./bootstrap.sh
    ./configure
    make
    sudo make install
    cd ..
    pip3 install yara-python

    echo ""
    echo "Installing 7ZIP and UPX"
    echo "-----------------------"
    sudo yum install -y p7zip p7zip-plugins
    sudo yum install -y upx


    echo ""
    echo "Installing telfhash"
    echo "-----------------------"
    wget https://github.com/trendmicro/tlsh/archive/master.zip -O master.zip
    unzip master.zip
    cd tlsh-master
    make.sh
    cd ..
    git clone https://github.com/trendmicro/telfhash.git
    cd telfhash
    python3 setup.py build
    python3 setup.py install
    cd ..
    cd ..

    echo ""
    echo "Installing python packages"
    echo "--------------------------"
    pip3 install wheel
    pip3 install cffi
    sudo yum install -y libarchive-devel
    pip3 install -r requirements.txt 
fi


echo "---------------------------"
echo "Writing to confg.txt, use the file in d20 with the '-c' flag"
echo "---------------------------"
cat > config.txt <<- EOF
# d20:
#     extra-players: $PWD/Players
#     extra-npcs: $PWD/NPCs
#     extra-facts: $PWD/Facts
#     extra-screens: $PWD/Screens
#     extra-actions: $PWD/Actions
#     extra-backstories: $PWD/Backstories
# Actions:
# #     un7z:
# #         password: None  # str
# #     unrar:
# #         password: None  # str
# #     unzip:
# #         password: None  # str
# #     virustotal:
# #         uri: None  # str
# #         api_key: None  # str
# Backstories:
# #     BulkAnalyze:
# #         test: false  # bool
# #     VTDownload:
# #         test: false  # bool
# NPCS:
# #     HashNPC:
# #     MimeTypeNPC:
# #     Strings:
# #         disable: false  # bool
# #         stringmodifier: 15  # int
# #         stringtype: ['all']  # list
# #     VirusTotal:
# #         disable: false  # bool
# #     YARA:
# #         disable: false  # bool
# #         rules: []  # list
# Players:
# #     .NET Metadata Extractor:
# #         disable: false  # bool
# #     Decompress:
# #         disable: false  # bool
# #         password: None  # str
# #     ELFMeta:
# #         disable: false  # bool
# #         resolve_ordinals: true  # bool
# #         ctor: true  # bool
# #         exported_symbols: true  # bool
# #         dynamic_entries: true  # bool
# #         dynamic_symbols: true  # bool
# #         functions: true  # bool
# #         gnu_hash: true  # bool
# #         header: true  # bool
# #         imported_symbols: true  # bool
# #         information: true  # bool
# #         notes: true  # bool
# #         relocations: true  # bool
# #         sections: true  # bool
# #         segments: true  # bool
# #         static_symbols: true  # bool
# #         sysv_hash: true  # bool
# #         telfhash: true  # bool
# #     EXIFTool:
# #         disable: false  # bool
# #     Lazy Zip Append Extractor:
# #         disable: false  # bool
# #     MachOMeta:
# #         disable: false  # bool
# #         information: true  # bool
# #         header: true  # bool
# #         commands: true  # bool
# #         libraries: true  # bool
# #         segments: true  # bool
# #         sections: true  # bool
# #         symbols: true  # bool
# #         symbol_command: true  # bool
# #         dynamic_symbol_command: true  # bool
# #         uuid: true  # bool
# #         main_command: true  # bool
# #         thread_command: true  # bool
# #         rpath_command: true  # bool
# #         dylinker: true  # bool
# #         function_starts: true  # bool
# #         data_in_code: true  # bool
# #         segment_split_info: true  # bool
# #         sub_framework: true  # bool
# #         dyld_environment: true  # bool
# #         dyld_info: true  # bool
# #         rebase_opcodes: true  # bool
# #         bind_opcodes: true  # bool
# #         weak_bind_opcodes: true  # bool
# #         lazy_bind_opcodes: true  # bool
# #         export_trie: true  # bool
# #         source_version: true  # bool
# #         version_min: true  # bool
# #         relocations: true  # bool
# #         encryption_info: true  # bool
# #         ctor: true  # bool
# #         unwind_functions: true  # bool
# #         functions: true  # bool
# #     PDFMeta:
# #         disable: false  # bool
# #     PEMeta:
# #         disable: false  # bool
# #         resolve_ordinals: true  # bool
# #         ctor: true  # bool
# #         data_directories: true  # bool
# #         debug: true  # bool
# #         exception_functions: true  # bool
# #         exports: true  # bool
# #         functions: true  # bool
# #         header: true  # bool
# #         imports: true  # bool
# #         information: true  # bool
# #         resources: true  # bool
# #         resource_data: true  # bool
# #         load_configuration: true  # bool
# #         relocations: true  # bool
# #         rich_header: true  # bool
# #         sections: true  # bool
# #         section_data: true  # bool
# #         signature: true  # bool
# #         symbols: true  # bool
# #         tls: true  # bool
# #     PIVY Binary Dumper:
# #         disable: false  # bool
# #     PyInstaller:
# #         disable: false  # bool
# #     PycDecompiler:
# #     RTFMeta:
# #         disable: false  # bool
# #     RestoreShiftedOle:
# #         disable: false  # bool
# #     Trinity Detection:
# #         disable: false  # bool
# #     Unpack:
# #         disable: false  # bool
# #     VBAExtract:
# #         disable: false  # bool
# Screens:
# #     decoders:
# #         exclude: []  # list
# #         remove_object_data: false  # bool
# #         include_core_facts: false  # bool
# #         convert_bytes: true  # bool
# #     high-level:
# #         exclude: []  # list
# #         remove_object_data: false  # bool
# #         include_core_facts: false  # bool
# #         convert_bytes: true  # bool
# #     json:
# #         exclude:   # list
# #         exclude_objects: false  # bool
# #         convert_bytes: true  # bool
# #         include_core_facts: false  # bool
# #     json_by_object:
# #         exclude: []  # list
# #         remove_object_data: false  # bool
# #         include_core_facts: false  # bool
# #         convert_bytes: true  # bool
# #     visjs:
# #         exclude: []  # list
# #         object_color: None  # str
# #         fact_color: None  # str
# #         object_edge_color: None  # str
# #         fact_edge_color: None  # str
# #     yaml:
# #     yaml_by_object:
# #         exclude: []  # list
# #         remove_object_data: false  # bool
# #         include_core_facts: false  # bool
# #         convert_bytes: true  # bool
# #     yara:
# #         exclude: []  # list
# #         remove_object_data: false  # bool
# #         include_core_facts: false  # bool
# #         convert_bytes: true  # bool    
# EOF