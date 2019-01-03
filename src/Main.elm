module Main exposing (main)

import Array
import Browser
import Html exposing (Html, button, div, h1, hr, li, ol, p, span, text)
import Html.Events exposing (onClick)
import Random
import Time



-- TODO: New rules
-- MODEL


type alias Model =
    { object : String
    , rule : String
    , timeRemaining : Int
    , score1 : Int
    , score2 : Int
    , showRules : Bool
    }



-- INIT


type Msg
    = GetNewObject
    | NewObject Int
    | GetNewRule
    | NewRule Int
    | NewTimer
    | NewTime Time.Posix
    | IncrScore1
    | DecrScore1
    | IncrScore2
    | DecrScore2
    | ShowInstructions
    | HideInstructions


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "???" "???" 0 0 0 False, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNewObject ->
            ( model, Random.generate NewObject (Random.int 0 (Array.length objects - 1)) )

        NewObject newObjectIndex ->
            ( { model | object = Maybe.withDefault "!" (Array.get newObjectIndex objects) }, Cmd.none )

        GetNewRule ->
            ( model, Random.generate NewRule (Random.int 0 (Array.length rules - 1)) )

        NewRule newRuleIndex ->
            ( { model | rule = Maybe.withDefault "!" (Array.get newRuleIndex rules) }, Cmd.none )

        NewTimer ->
            ( { model | timeRemaining = timeLimit }, Cmd.none )

        NewTime _ ->
            ( { model | timeRemaining = model.timeRemaining - 1 }, Cmd.none )

        IncrScore1 ->
            ( { model | score1 = intToScore <| model.score1 + 1 }, Cmd.none )

        DecrScore1 ->
            ( { model | score1 = intToScore <| model.score1 - 1 }, Cmd.none )

        IncrScore2 ->
            ( { model | score2 = intToScore <| model.score2 + 1 }, Cmd.none )

        DecrScore2 ->
            ( { model | score2 = intToScore <| model.score2 - 1 }, Cmd.none )

        ShowInstructions ->
            ( { model | showRules = True }, Cmd.none )

        HideInstructions ->
            ( { model | showRules = False }, Cmd.none )



-- UPDATE HELPERS


intToScore : Int -> Int
intToScore score =
    if score < 0 then
        0

    else if score > maxScore then
        maxScore

    else
        score



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 NewTime



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ -- INSTRUCTIONS
          if model.showRules then
            div []
                [ button [ onClick HideInstructions ] [ text "Hide instructions" ]
                , ol []
                    [ li [] [ text "With at least 4 players, make 2 teams and pick 1 rep from each team." ]
                    , li [] [ text "Together, reps draw a single shared object. Teams will compete to guess this object." ]
                    , li [] [ text <| "Now each side takes turns, " ++ String.fromInt timeLimit ++ " seconds per side:" ]
                    , ol []
                        [ li [] [ text "Rep draws a random rule. Can skip once per round." ]
                        , li [] [ text "Rep gives a hint to their team obeying that rule." ]
                        , li [] [ text "Team must settle on a single guess per hint." ]
                        ]
                    , li [] [ text "The first team to guess the object gets 1 point." ]
                    , li [] [ text "After the object is guessed, each team picks 1 new rep. " ]
                    , li [] [ text "The first team to 7 points wins." ]
                    ]
                ]

          else
            div [] [ button [ onClick ShowInstructions ] [ text "View instructions" ] ]
        , hr [] []

        -- OBJECTS
        , button [ onClick GetNewObject ] [ text "New object" ]
        , h1 [] [ text <| "Your object: " ++ model.object ]
        , hr [] []

        -- HINT RULES
        , button [ onClick GetNewRule ] [ text "New rule" ]
        , h1 [] [ text <| "Give a hint using: " ++ model.rule ]
        , hr [] []

        -- TIME
        , button [ onClick NewTimer ] [ text "New timer" ]
        , if model.timeRemaining > 0 then
            h1 [] [ text <| String.fromInt model.timeRemaining ++ "s" ]

          else
            h1 [] [ text "Out of time!" ]
        , hr [] []

        -- SCORE
        , if model.score1 >= maxScore then
            h1 [] [ text "Team 1 wins!" ]

          else if model.score2 >= maxScore then
            h1 [] [ text "Team 2 wins!" ]

          else
            h1 [] [ text <| "First team to " ++ String.fromInt maxScore ++ " wins!" ]
        , p []
            [ text "Team 1: "
            , button [ onClick DecrScore1 ] [ text "-" ]
            , span [] [ text <| String.fromInt model.score1 ]
            , button [ onClick IncrScore1 ] [ text "+" ]
            ]
        , p []
            [ text "Team 2: "
            , button [ onClick DecrScore2 ] [ text "-" ]
            , span [] [ text <| String.fromInt model.score2 ]
            , button [ onClick IncrScore2 ] [ text "+" ]
            ]
        ]



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- CONSTANTS


maxScore =
    7


timeLimit =
    45


rules =
    Array.fromList
        [ "One word that rhymes with ___"
        , "One word that starts with the letter _"
        , "One Texture word"
        , "One Emotion word"
        , "One Action word"
        , "One Sight word"
        , "One Color word"
        , "One Size word"
        , "One Smell word"
        , "One Taste word"
        , "One word of any kind"
        , "A number (like 17 or π)"
        , "Only sound effects"
        , "Only hand motions"
        ]


objects =
    Array.fromList
        [ "aardvark", "accelerator", "accordion", "account", "accountant", "acknowledgment", "acoustic", "acrylic", "act", "action", "activity", "actor", "actress", "adapter", "addition", "address", "adjustment", "advantage", "advertisement", "advice", "aftermath", "afternoon", "aftershave", "afterthought", "age", "agenda", "agreement", "air", "airbus", "airmail", "airplane", "airport", "airship", "alarm", "albatross", "alcohol", "algebra", "alibi", "alley", "alligator", "alloy", "almanac", "alphabet", "alto", "aluminium", "aluminum", "ambulance", "amount", "amusement", "anatomy", "anger", "angle", "animal", "anime", "ankle", "answer", "ant", "anteater", "anthropology", "apartment", "apology", "apparatus", "apparel", "appeal", "appendix", "apple", "appliance", "approval", "arch", "archaeology", "archeology", "archer", "architecture", "area", "argument", "arithmetic", "arm", "armadillo", "armchair", "army", "arrow", "art", "ash", "ashtray", "asparagus", "asphalt", "asterisk", "astronomy", "athlete", "atom", "attack", "attempt", "attention", "attic", "attraction", "aunt", "author", "authority", "authorization", "avenue", "baboon", "baby", "back", "backbone", "bacon", "badge", "badger", "bag", "bagel", "bagpipe", "bail", "bait", "baker", "bakery", "balance", "ball", "balloon", "bamboo", "banana", "band", "bandana", "banjo", "bank", "bankbook", "banker", "bar", "barber", "barge", "baritone", "barometer", "base", "baseball", "basement", "basin", "basket", "basketball", "bass", "bassoon", "bat", "bath", "bathroom", "bathtub", "battery", "battle", "bay", "beach", "bead", "beam", "bean", "bear", "beard", "beast", "beat", "beauty", "beaver", "bed", "bedroom", "bee", "beech", "beef", "beer", "beet", "beetle", "beggar", "beginner", "begonia", "behavior", "belief", "believe", "bell", "belt", "bench", "beret", "berry", "bestseller", "bibliography", "bicycle", "bike", "bill", "billboard", "biology", "biplane", "birch", "bird", "birth", "birthday", "bit", "bite", "black", "bladder", "blade", "blanket", "blinker", "blizzard", "block", "blood", "blouse", "blow", "blowgun", "blue", "board", "boat", "bobcat", "body", "bomb", "bomber", "bone", "bonsai", "book", "bookcase", "booklet", "boot", "border", "botany", "bottle", "bottom", "boundary", "bow", "bowling", "box", "boy", "bra", "brace", "bracket", "brain", "brake", "branch", "brand", "brandy", "brass", "bread", "break", "breakfast", "breath", "brick", "bridge", "broccoli", "brochure", "broker", "bronze", "brother", "brow", "brown", "brush", "bubble", "bucket", "budget", "buffer", "buffet", "bugle", "building", "bulb", "bull", "bulldozer", "bumper", "bun", "burglar", "burn", "burst", "bus", "bush", "business", "butane", "butcher", "butter", "button", "buzzard", "cabbage", "cabinet", "cable", "cactus", "cafe", "cake", "calculator", "calculus", "calendar", "calf", "call", "camel", "camera", "camp", "candle", "cannon", "canoe", "canvas", "cap", "capital", "cappelletti", "captain", "caption", "car", "carbon", "card", "cardboard", "cardigan", "care", "carnation", "carp", "carpenter", "carriage", "carrot", "cart", "cartoon", "case", "cast", "castanet", "cat", "catamaran", "caterpillar", "cathedral", "catsup", "cattle", "cauliflower", "cause", "caution", "cave", "ceiling", "celery", "celeste", "cell", "cellar", "cello", "cement", "cemetery", "cent", "centimeter", "century", "ceramic", "cereal", "certification", "chain", "chair", "chalk", "chance", "change", "channel", "character", "chard", "chauffeur", "check", "cheek", "cheetah", "chef", "chemistry", "cheque", "cherry", "chess", "chest", "chick", "chicken", "chicory", "chief", "child", "children", "chill", "chimpanzee", "chin", "chive", "chocolate", "chord", "chronometer", "church", "cicada", "cinema", "circle", "circulation", "cirrus", "citizenship", "city", "clam", "clarinet", "clave", "clef", "clerk", "click", "client", "climb", "clipper", "cloakroom", "clock", "close", "closet", "cloth", "cloud", "cloudy", "clover", "club", "clutch", "coach", "coal", "coast", "coat", "cobweb", "cockroach", "cocktail", "cocoa", "cod", "coffee", "coil", "coin", "coke", "cold", "collar", "college", "collision", "colon", "colony", "color", "colt", "column", "columnist", "comb", "comfort", "comma", "command", "commission", "committee", "community", "company", "comparison", "competition", "competitor", "composer", "composition", "computer", "condition", "condor", "cone", "confirmation", "conga", "conifer", "connection", "consonant", "continent", "control", "cook", "cooking", "copper", "copy", "copyright", "cord", "cork", "cormorant", "corn", "cornet", "correspondent", "cost", "cotton", "couch", "cougar", "cough", "country", "course", "court", "cousin", "cover", "cow", "cowbell", "crab", "crack", "cracker", "craftsman", "crate", "crawdad", "crayfish", "crayon", "cream", "creator", "creature", "credit", "creditor", "creek", "crib", "cricket", "crime", "criminal", "crocodile", "crocus", "croissant", "crook", "crop", "cross", "crow", "crowd", "crown", "crush", "cry", "cub", "cucumber", "cultivator", "cup", "cupboard", "curler", "currency", "current", "curtain", "curve", "cushion", "customer", "cut", "cuticle", "cycle", "cyclone", "cylinder", "cymbal", "dad", "daffodil", "dahlia", "daisy", "damage", "dance", "danger", "dash", "dashboard", "database", "date", "daughter", "day", "dead", "deadline", "deal", "death", "debt", "debtor", "decade", "decimal", "decision", "decrease", "dedication", "deer", "defense", "deficit", "degree", "delete", "delivery", "den", "denim", "dentist", "deodorant", "department", "deposit", "description", "desert", "design", "desire", "desk", "dessert", "destruction", "detail", "detective", "development", "dew", "diamond", "diaphragm", "dibble", "dictionary", "difference", "digestion", "digger", "digital", "dill", "dime", "dimple", "dinghy", "dinner", "dinosaur", "diploma", "dipstick", "direction", "dirt", "disadvantage", "discovery", "discussion", "disease", "disgust", "dish", "distance", "distribution", "distributor", "diving", "division", "dock", "doctor", "dog", "dogsled", "doll", "dollar", "dolphin", "domain", "donkey", "door", "double", "doubt", "downtown", "dragon", "dragonfly", "drain", "drake", "drama", "draw", "drawbridge", "drawer", "dream", "dredger", "dress", "dresser", "dressing", "drill", "drink", "drive", "driver", "driving", "drizzle", "drop", "drug", "drum", "dry", "dryer", "duck", "duckling", "dugout", "dungeon", "dust", "eagle", "ear", "earth", "earthquake", "ease", "east", "edge", "edger", "editor", "editorial", "education", "eel", "effect", "egg", "eggnog", "eggplant", "eight", "elbow", "element", "elephant", "ellipse", "emery", "employee", "employer", "encyclopedia", "end", "enemy", "energy", "engine", "engineer", "engineering", "enquiry", "entrance", "environment", "epoch", "epoxy", "equinox", "equipment", "era", "error", "estimate", "ethernet", "euphonium", "evening", "event", "examination", "example", "exchange", "exclamation", "exhaust", "existence", "expansion", "experience", "expert", "explanation", "eye", "eyebrow", "eyeliner", "face", "facilities", "fact", "factory", "fairies", "fall", "family", "fan", "fang", "farm", "farmer", "fat", "father", "faucet", "fear", "feast", "feather", "feature", "fedelini", "feedback", "feeling", "feet", "felony", "female", "fender", "ferry", "ferryboat", "fiber", "fiberglass", "fibre", "fiction", "field", "fifth", "fight", "fighter", "file", "find", "fine", "finger", "fir", "fire", "fireman", "fireplace", "firewall", "fish", "fisherman", "flag", "flame", "flare", "flat", "flavor", "flax", "flesh", "flight", "flock", "flood", "floor", "flower", "flugelhorn", "flute", "fly", "foam", "fog", "fold", "font", "food", "foot", "football", "footnote", "force", "forecast", "forehead", "forest", "forgery", "fork", "form", "format", "fortnight", "foundation", "fountain", "fowl", "fox", "foxglove", "fragrance", "frame", "freckle", "freeze", "freezer", "freighter", "freon", "friction", "friend", "frog", "front", "frost", "fruit", "fuel", "fur", "furniture", "galley", "gallon", "game", "gander", "garage", "garden", "garlic", "gas", "gasoline", "gate", "gateway", "gauge", "gazelle", "gear", "gearshift", "geese", "gender", "geography", "geology", "geometry", "geranium", "ghost", "giraffe", "girdle", "girl", "gladiolus", "glass", "glider", "gliding", "glockenspiel", "glove", "glue", "goal", "goat", "gold", "goldfish", "golf", "gondola", "gong", "goose", "gorilla", "gosling", "government", "governor", "grade", "grain", "gram", "granddaughter", "grandfather", "grandmother", "grandson", "grape", "graphic", "grass", "grasshopper", "gray", "grease", "green", "grenade", "grey", "grill", "grip", "ground", "group", "grouse", "growth", "guarantee", "guide", "guilty", "guitar", "gum", "gun", "gym", "gymnast", "hacksaw", "hail", "hair", "haircut", "halibut", "hall", "hallway", "hamburger", "hammer", "hamster", "hand", "handball", "handicap", "handle", "handsaw", "harbor", "hardboard", "hardcover", "hardhat", "hardware", "harmonica", "harmony", "harp", "hat", "hate", "hawk", "head", "headlight", "headline", "health", "hearing", "heart", "heat", "heaven", "hedge", "height", "helicopter", "helium", "hell", "helmet", "help", "hemp", "hen", "heron", "herring", "hexagon", "hill", "hip", "hippopotamus", "history", "hockey", "hoe", "hole", "holiday", "home", "honey", "hood", "hook", "hope", "horn", "horse", "hose", "hospital", "hot", "hour", "hourglass", "house", "hovercraft", "hub", "hubcap", "humidity", "humor", "hurricane", "hyacinth", "hydrant", "hydrofoil", "hydrogen", "hyena", "hygienic", "ice", "icebreaker", "icicle", "icon", "idea", "ikebana", "illegal", "imprisonment", "improvement", "impulse", "inch", "income", "increase", "index", "industry", "ink", "innocent", "input", "insect", "instruction", "instrument", "insulation", "insurance", "interactive", "interest", "interviewer", "intestine", "invention", "inventory", "invoice", "iris", "iron", "island", "jacket", "jaguar", "jail", "jam", "jar", "jasmine", "jaw", "jeans", "jeep", "jelly", "jellyfish", "jet", "jewel", "jogging", "join", "joke", "journey", "judge", "judo", "juice", "jumbo", "jump", "jumper", "jury", "justice", "jute", "kale", "kamikaze", "kangaroo", "karate", "kayak", "kendo", "ketchup", "kettle", "kettledrum", "key", "keyboard", "keyboarding", "kick", "kilogram", "kilometer", "kiss", "kitchen", "kite", "kitten", "kitty", "knee", "knickers", "knife", "knight", "knot", "knowledge", "kohlrabi", "laborer", "lace", "ladybug", "lake", "lamb", "lamp", "lan", "land", "landmine", "language", "larch", "lasagna", "latency", "latex", "lathe", "laugh", "laundry", "law", "lawyer", "layer", "lead", "leaf", "learning", "leather", "leek", "leg", "legal", "lemonade", "lentil", "letter", "lettuce", "level", "license", "lier", "lift", "light", "lightning", "lilac", "lily", "limit", "line", "linen", "link", "lion", "lip", "lipstick", "liquid", "liquor", "list", "literature", "litter", "liver", "lizard", "llama", "loaf", "loan", "lobster", "lock", "locket", "locust", "look", "loss", "lotion", "love", "low", "lumber", "lunch", "lunchroom", "lung", "lute", "luttuce", "lycra", "lynx", "lyocell", "lyre", "lyric", "macaroni", "machine", "macrame", "magazine", "magic", "maid", "mail", "mailbox", "mailman", "makeup", "male", "mall", "mallet", "man", "manager", "mandolin", "manicure", "map", "maple", "maraca", "marble", "margin", "marimba", "mark", "market", "mascara", "mask", "mass", "match", "math", "mattock", "mayonnaise", "meal", "measure", "meat", "mechanic", "medicine", "meeting", "melody", "memory", "men", "menu", "mercury", "message", "metal", "meteorology", "meter", "methane", "mice", "microwave", "middle", "mile", "milk", "milkshake", "millennium", "millimeter", "millisecond", "mimosa", "mind", "mine", "minibus", "minister", "mint", "minute", "mirror", "missile", "mist", "mistake", "mitten", "moat", "modem", "mole", "mom", "money", "monkey", "month", "moon", "morning", "mosque", "mosquito", "mother", "motion", "motorboat", "motorcycle", "mountain", "mouse", "moustache", "mouth", "move", "multimedia", "muscle", "museum", "music", "mustard", "nail", "name", "napkin", "nation", "neck", "need", "needle", "neon", "nephew", "nerve", "nest", "net", "network", "news", "newsprint", "newsstand", "nickel", "niece", "night", "nitrogen", "node", "noise", "noodle", "north", "nose", "note", "notebook", "notify", "novel", "number", "numeric", "nurse", "nut", "nylon", "oak", "oatmeal", "objective", "oboe", "observation", "occupation", "ocean", "ocelot", "octagon", "octave", "octopus", "odometer", "offence", "offer", "office", "oil", "okra", "olive", "onion", "open", "opera", "operation", "opinion", "option", "orange", "orchestra", "orchid", "order", "organ", "organisation", "organization", "ornament", "ostrich", "otter", "ounce", "output", "outrigger", "oval", "oven", "overcoat", "owl", "owner", "oxygen", "oyster", "packet", "page", "pail", "pain", "paint", "pair", "pajama", "pamphlet", "pan", "pancake", "pancreas", "panda", "pansy", "panther", "panties", "pantry", "pants", "panty", "pantyhose", "paper", "paperback", "parade", "parallelogram", "parcel", "parent", "parentheses", "park", "parrot", "parsnip", "part", "particle", "partner", "partridge", "party", "passbook", "passenger", "passive", "pasta", "paste", "pastor", "pastry", "patch", "path", "patient", "patio", "payment", "pea", "peace", "peak", "peanut", "pear", "peen", "pelican", "pen", "penalty", "pencil", "pendulum", "pentagon", "peony", "pepper", "perch", "perfume", "period", "periodical", "peripheral", "permission", "person", "pest", "pet", "pharmacist", "pheasant", "philosophy", "phone", "piano", "piccolo", "pickle", "picture", "pie", "pig", "pigeon", "pike", "pillow", "pilot", "pimple", "pin", "pine", "ping", "pink", "pint", "pipe", "pizza", "place", "plain", "plane", "plant", "plantation", "plaster", "plasterboard", "plastic", "plate", "platinum", "play", "playground", "playroom", "pleasure", "plier", "plot", "plough", "plow", "plywood", "pocket", "poet", "point", "poison", "police", "policeman", "polish", "pollution", "polo", "polyester", "pond", "popcorn", "poppy", "porch", "porcupine", "port", "porter", "position", "possibility", "postage", "postbox", "pot", "potato", "poultry", "pound", "powder", "power", "precipitation", "preface", "pressure", "price", "priest", "print", "printer", "prison", "probation", "process", "processing", "produce", "product", "production", "professor", "profit", "promotion", "propane", "property", "prose", "prosecution", "protest", "protocol", "pruner", "psychiatrist", "psychology", "ptarmigan", "puffin", "pull", "puma", "pump", "pumpkin", "punch", "punishment", "puppy", "purchase", "purple", "purpose", "push", "pyjama", "pyramid", "quail", "quality", "quart", "quarter", "quartz", "queen", "question", "quicksand", "quiet", "quill", "quilt", "quince", "quit", "quiver", "quotation", "rabbi", "rabbit", "racing", "radar", "radiator", "radio", "radish", "raft", "rail", "railway", "rain", "rainbow", "raincoat", "rainstorm", "rake", "ramie", "random", "range", "rat", "rate", "raven", "ravioli", "ray", "rayon", "reaction", "reading", "reason", "receipt", "recess", "record", "recorder", "rectangle", "red", "reduction", "refrigerator", "refund", "regret", "reindeer", "relation", "religion", "relish", "reminder", "repair", "replace", "report", "representative", "request", "resolution", "respect", "responsibility", "rest", "restaurant", "result", "retailer", "revolve", "revolver", "reward", "rhinoceros", "rhythm", "rice", "riddle", "rifle", "ring", "rise", "risk", "river", "riverbed", "road", "roadway", "roast", "robin", "rock", "rod", "roll", "roof", "room", "rooster", "root", "rose", "rotate", "route", "router", "rowboat", "rub", "rubber", "rugby", "rule", "run", "rutabaga", "sack", "sail", "sailboat", "sailor", "salad", "salary", "sale", "salesman", "salmon", "salt", "sampan", "samurai", "sand", "sandwich", "sardine", "satin", "sauce", "sausage", "save", "saw", "saxophone", "scale", "scallion", "scanner", "scarecrow", "scarf", "scene", "scent", "schedule", "school", "science", "scissors", "scooter", "scraper", "screw", "screwdriver", "sea", "seagull", "seal", "seaplane", "search", "seashore", "season", "seat", "second", "secretary", "secure", "security", "seed", "seeder", "segment", "select", "selection", "self", "semicircle", "semicolon", "sense", "sentence", "servant", "server", "session", "sex", "shade", "shadow", "shake", "shallot", "shame", "shampoo", "shape", "share", "shark", "shears", "sheep", "sheet", "shelf", "shell", "shield", "shingle", "ship", "shirt", "shock", "shoe", "shoemaker", "shop", "shorts", "shoulder", "shovel", "show", "shrimp", "shrine", "side", "sideboard", "sidecar", "sidewalk", "sign", "signature", "silica", "silk", "silver", "sing", "singer", "single", "sink", "sister", "size", "skate", "skiing", "skill", "skin", "skirt", "sky", "slash", "slave", "sled", "sleep", "sleet", "slice", "slip", "slippers", "slope", "smash", "smell", "smile", "smoke", "snail", "snake", "sneeze", "snow", "snowboarding", "snowflake", "snowman", "snowplow", "snowstorm", "soap", "soccer", "society", "sociology", "sock", "soda", "sofa", "softball", "softdrink", "software", "soldier", "son", "song", "soprano", "sound", "soup", "sousaphone", "soy", "soybean", "space", "spade", "spaghetti", "spandex", "spark", "sparrow", "spear", "specialist", "speedboat", "sphere", "spider", "spinach", "spleen", "sponge", "spoon", "spot", "spring", "sprout", "spruce", "spy", "square", "squash", "squid", "squirrel", "stage", "staircase", "stamp", "star", "start", "starter", "state", "statement", "station", "statistic", "steam", "steel", "stem", "step", "stepdaughter", "stepmother", "stepson", "stew", "stick", "stitch", "stock", "stocking", "stomach", "stone", "stool", "stop", "stopwatch", "store", "storm", "story", "stove", "stranger", "straw", "stream", "street", "streetcar", "stretch", "string", "structure", "study", "sturgeon", "submarine", "substance", "subway", "success", "suede", "sugar", "suggestion", "suit", "summer", "sun", "sundial", "sunflower", "supermarket", "supply", "support", "surfboard", "surgeon", "surname", "surprise", "sushi", "swallow", "swamp", "swan", "sweater", "sweatshirt", "sweatshop", "sweets", "swim", "swimming", "swing", "switch", "sword", "swordfish", "sycamore", "syrup", "system", "table", "tachometer", "tadpole", "tail", "tailor", "talk", "tank", "tanker", "target", "taste", "tax", "taxi", "taxicab", "tea", "teacher", "teaching", "team", "teeth", "television", "teller", "temper", "temperature", "temple", "tempo", "tendency", "tennis", "tenor", "tent", "territory", "test", "text", "textbook", "texture", "theater", "theory", "thermometer", "thing", "thistle", "thought", "thread", "thrill", "throat", "throne", "thumb", "thunder", "thunderstorm", "ticket", "tie", "tiger", "tights", "tile", "time", "timer", "timpani", "tin", "tip", "tire", "titanium", "title", "toad", "toast", "toe", "toilet", "tomato", "ton", "tongue", "tooth", "toothbrush", "toothpaste", "top", "tornado", "tortellini", "tortoise", "touch", "tower", "town", "toy", "tractor", "trade", "traffic", "trail", "train", "tramp", "transaction", "transmission", "transport", "trapezoid", "tray", "treatment", "tree", "trial", "triangle", "trick", "trigonometry", "trip", "trombone", "trouble", "trousers", "trout", "trowel", "truck", "trumpet", "trunk", "tsunami", "tub", "tuba", "tugboat", "tulip", "tuna", "tune", "turn", "turnip", "turnover", "turret", "turtle", "twig", "twilight", "twine", "twist", "typhoon", "tyvek", "umbrella", "uncle", "underclothes", "underpants", "undershirt", "underwear", "unit", "utensil", "vacation", "vacuum", "valley", "value", "van", "vase", "vault", "vegetable", "veil", "vein", "velvet", "verdict", "vermicelli", "verse", "vessel", "vest", "vibraphone", "view", "vinyl", "viola", "violet", "violin", "viscose", "vise", "vision", "visitor", "voice", "volcano", "volleyball", "voyage", "vulture", "waiter", "waitress", "wall", "wallaby", "walrus", "war", "wash", "washer", "wasp", "waste", "watch", "watchmaker", "water", "waterfall", "wave", "wax", "way", "wealth", "weapon", "weasel", "weather", "wedge", "weeder", "week", "weight", "whale", "wheel", "whip", "whiskey", "whistle", "white", "wholesaler", "whorl", "wilderness", "willow", "wind", "window", "windscreen", "windshield", "wine", "wing", "winter", "wire", "wish", "withdrawal", "witness", "wolf", "women", "wood", "wool", "woolen", "word", "work", "workshop", "worm", "wound", "wrecker", "wren", "wrench", "wrist", "writer", "xylophone", "yacht", "yam", "yard", "year", "yellow", "yew", "yogurt", "zebra", "zinc", "zone", "zoology" ]
