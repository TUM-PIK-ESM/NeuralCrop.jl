using Documenter

push!(LOAD_PATH, dirname(@__DIR__))

using NeuralCrop

DocMeta.setdocmeta!(NeuralCrop, :DocTestSetup, :(using NeuralCrop); recursive = true)

const CHECK_LINKS = parse(Bool, get(ENV, "CHECK_LINKS", "false"))

makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        ansicolor = true,
        collapselevel = 1,
        repolink = "https://github.com/yunan-l/NeuralCrop.jl",
        canonical = "https://yunan-l.github.io/NeuralCrop.jl",
        mathengine = Documenter.MathJax3(),
    ),
    sitename = "NeuralCrop.jl",
    authors = "Yunan Lin and contributors",
    modules = [NeuralCrop],
    pages = [
        "Home" => "index.md",
        "Introduction" => [
            "Basic concepts" => "introduction/basic_concepts.md",
            "Software architecture" => "introduction/software_architecture.md",
            "Mathematical formulation" => "introduction/mathematical_formulation.md",
        ],
        "Running NeuralCrop" => [
            "Installation" => "running/installation.md",
            "Input data" => "running/input_data.md",
            "Initialization" => "running/initialization.md",
            "Daily simulations" => "running/daily_simulations.md",
            "Training" => "running/training.md",
        ],
        "Extending NeuralCrop" => [
            "Core interfaces" => "extending/core_interfaces.md",
            "Adding process modules" => "extending/adding_process_modules.md",
            "Hybrid components" => "extending/hybrid_components.md",
        ],
        "Models" => [
            "Crop model" => "models/crop_model.md",
            "Soil model" => "models/soil_model.md",
            "Hybrid model" => "models/hybrid_model.md",
        ],
        "Processes" => [
            "Climate" => [
                "Overview" => "processes/climate/overview.md",
            ],
            "Crop" => [
                "Overview" => "processes/crop/overview.md",
                "Photosynthesis" => "processes/crop/photosynthesis.md",
                "Phenology and management" => "processes/crop/phenology_management.md",
                "Carbon and nitrogen" => "processes/crop/carbon_nitrogen.md",
            ],
            "Soil" => [
                "Overview" => "processes/soil/overview.md",
                "Water" => "processes/soil/water.md",
                "Carbon and nitrogen" => "processes/soil/carbon_nitrogen.md",
            ],
            "Hybrid components" => "processes/hybrid/overview.md",
            "Neural networks" => "processes/neural_network/overview.md",
            "Utilities" => "processes/utilities/overview.md",
        ],
        "Contributing" => "contributing.md",
        "API index" => "api_index.md",
        "References" => "references.md",
    ],
    linkcheck = CHECK_LINKS,
    warnonly = [:cross_references],
)

deploydocs(
    repo = "github.com/yunan-l/NeuralCrop.jl.git",
    push_preview = true,
    versions = ["dev" => "dev", "v#.#" => "v#.#"],
)
