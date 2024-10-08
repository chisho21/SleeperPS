
#
# Module manifest for module 'Sleeper'
#
# Generated by: Evan Chisholm
#
# Generated on: 2024-09-10
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'SleeperPS.psm1'
    
    # Version number of this module.
    ModuleVersion = '0.2.1'
    
    # Author of this module
    Author = 'Evan Chisholm'
    
    # Company or vendor of this module
    CompanyName = 'Feros Technologies'
    
    # Copyright statement for this module
    Copyright = '© 2024 Feros Technologies. This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

You are free to:
- Share — copy and redistribute the material in any medium or format.
- Adapt — remix, transform, and build upon the material.

Under the following terms:
- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
- NonCommercial — You may not use the material for commercial purposes.
- ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

For more information, visit: https://creativecommons.org/licenses/by-nc-sa/4.0/
'
    
    # Description of the functionality provided by this module
    Description = 'PSModule for interacting with sleeper.com API'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'
    
    # ID used to uniquely identify this module
    GUID = '6e7d87be-6d6a-4958-941d-90cc932f355c'
    
    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''
    
    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''
    
    # Minimum version of Microsoft .NET Framework required by this module
    # DotNetFrameworkVersion = ''
    
    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = ''
    
    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''
    
    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @(
    #     @{ ModuleName = 'ImportExcel'; ModuleVersion = '7.1.1' }
    # )
    
    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()
    
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()
    
    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()
    
    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @('SleeperPS.ps1xml')
    
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()
    
    # Functions to export from this module
    FunctionsToExport = '*'
    # Cmdlets to export from this module
    CmdletsToExport = '*'
    
    # Variables to export from this module
    VariablesToExport = '*'
    
    # Aliases to export from this module
    AliasesToExport = '*'
    
    # DSC resources to export from this module
    # DscResourcesToExport = @()
    
    # List of all modules packaged with this module
    #ModuleList = @()
    
    # List of all files packaged with this module
    #FileList = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('PSModule','Sleeper','API')
    
            # A URL to the license for this module.
            # LicenseUri = ''
    
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/chisho21/SleeperPS'
    
            # A URL to an icon representing this module.
            # IconUri = ''
    
            # ReleaseNotes of this module
            ReleaseNotes = ''
    
        } # End of PSData hashtable
    
    } # End of PrivateData hashtable
    
    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/chisho21/Sleeper/help'
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
    
}
    
    
