port module Main exposing (main)

import Array
import Browser
import Html exposing (Html, audio, button, div, h1, li, main_, p, span, text, ul)
import Html.Attributes exposing (class, controls, id, src)
import Html.Events exposing (onClick)
import Json.Encode as E
import Random
import Time



-- PORTING AUDIO COMMANDS


port playSfx : E.Value -> Cmd msg



-- GAME CONSTANTS


winScore : Int
winScore =
    7


timeLimit : Int
timeLimit =
    45


randomWord : Random.Generator String
randomWord =
    let
        words =
            Array.fromList [ "aardvark", "accordion", "account", "accountant", "acknowledgment", "acoustic", "acrylic", "act", "action", "activity", "actor", "actress", "adapter", "addition", "address", "adjustment", "advantage", "advertisement", "advice", "aftermath", "afternoon", "aftershave", "afterthought", "age", "agenda", "agreement", "air", "airbus", "airmail", "airplane", "airport", "airship", "alarm", "albatross", "alcohol", "algebra", "alibi", "alley", "alligator", "alloy", "almanac", "alphabet", "alto", "aluminium", "aluminum", "ambulance", "amount", "amusement", "anatomy", "anger", "angle", "animal", "anime", "ankle", "answer", "ant", "anteater", "anthropology", "apartment", "apology", "apparatus", "apparel", "appeal", "appendix", "apple", "appliance", "approval", "arch", "archaeology", "archeology", "archer", "architecture", "area", "argument", "arithmetic", "arm", "armadillo", "armchair", "army", "arrow", "art", "ash", "ashtray", "asparagus", "asphalt", "asterisk", "astronomy", "athlete", "atom", "attack", "attempt", "attention", "attic", "attraction", "aunt", "author", "authority", "authorization", "avenue", "baboon", "baby", "back", "backbone", "bacon", "badge", "badger", "bag", "bagel", "bagpipe", "bail", "bait", "baker", "bakery", "balance", "ball", "balloon", "bamboo", "banana", "band", "bandana", "banjo", "bank", "bankbook", "banker", "bar", "barber", "barge", "baritone", "barometer", "base", "baseball", "basement", "basin", "basket", "basketball", "bass", "bassoon", "bat", "bath", "bathroom", "bathtub", "battery", "battle", "bay", "beach", "bead", "beam", "bean", "bear", "beard", "beast", "beat", "beauty", "beaver", "bed", "bedroom", "bee", "beech", "beef", "beer", "beet", "beetle", "beggar", "beginner", "begonia", "behavior", "belief", "believe", "bell", "belt", "bench", "beret", "berry", "bestseller", "bibliography", "bicycle", "bike", "bill", "billboard", "biology", "biplane", "birch", "bird", "birth", "birthday", "bit", "bite", "bladder", "blade", "blanket", "blinker", "blizzard", "block", "blood", "blouse", "blow", "blowgun", "blue", "board", "boat", "bobcat", "body", "bomb", "bomber", "bone", "bonsai", "book", "bookcase", "booklet", "boot", "border", "botany", "bottle", "bottom", "boundary", "bow", "bowling", "box", "boy", "bra", "brace", "bracket", "brain", "brake", "branch", "brand", "brandy", "brass", "bread", "break", "breakfast", "breath", "brick", "bridge", "broccoli", "brochure", "broker", "bronze", "brother", "brow", "brush", "bubble", "bucket", "budget", "buffer", "buffet", "bugle", "building", "bulb", "bull", "bulldozer", "bumper", "bun", "burglar", "burn", "burst", "bus", "bush", "business", "butane", "butcher", "butter", "button", "buzzard", "cabbage", "cabinet", "cable", "cactus", "cafe", "cake", "calculator", "calculus", "calendar", "calf", "call", "camel", "camera", "camp", "candle", "cannon", "canoe", "canvas", "cap", "capital", "cappelletti", "captain", "caption", "car", "carbon", "card", "cardboard", "cardigan", "care", "carnation", "carp", "carpenter", "carriage", "carrot", "cart", "cartoon", "case", "cast", "castanet", "cat", "catamaran", "caterpillar", "cathedral", "catsup", "cattle", "cauliflower", "cause", "caution", "cave", "ceiling", "celery", "celeste", "cell", "cellar", "cello", "cement", "cemetery", "cent", "centimeter", "century", "ceramic", "cereal", "certification", "chain", "chair", "chalk", "chance", "change", "channel", "character", "chard", "chauffeur", "check", "cheek", "cheetah", "chef", "chemistry", "cheque", "cherry", "chess", "chest", "chick", "chicken", "chicory", "chief", "child", "children", "chill", "chimpanzee", "chin", "chive", "chocolate", "chord", "chronometer", "church", "cicada", "cinema", "circle", "circulation", "cirrus", "citizenship", "city", "clam", "clarinet", "clave", "clef", "clerk", "click", "client", "climb", "clipper", "cloakroom", "clock", "close", "closet", "cloth", "cloud", "cloudy", "clover", "club", "clutch", "coach", "coal", "coast", "coat", "cobweb", "cockroach", "cocktail", "cocoa", "cod", "coffee", "coil", "coin", "coke", "cold", "collar", "college", "collision", "colon", "colony", "colt", "column", "columnist", "comb", "comfort", "comma", "command", "commission", "committee", "community", "company", "comparison", "competition", "competitor", "composer", "composition", "computer", "condition", "condor", "cone", "confirmation", "conga", "conifer", "connection", "consonant", "continent", "control", "cook", "cooking", "copper", "copy", "copyright", "cord", "cork", "cormorant", "corn", "cornet", "correspondent", "cost", "cotton", "couch", "cougar", "cough", "country", "course", "court", "cousin", "cover", "cow", "cowbell", "crab", "crack", "cracker", "craftsman", "crate", "crawdad", "crayfish", "crayon", "cream", "creator", "creature", "credit", "creditor", "creek", "crib", "cricket", "crime", "criminal", "crocodile", "crocus", "croissant", "crook", "crop", "cross", "crow", "crowd", "crown", "crush", "cry", "cub", "cucumber", "cultivator", "cup", "cupboard", "curler", "currency", "current", "curtain", "curve", "cushion", "customer", "cut", "cuticle", "cycle", "cyclone", "cylinder", "cymbal", "dad", "daffodil", "dahlia", "daisy", "damage", "dance", "danger", "dash", "dashboard", "database", "date", "daughter", "day", "dead", "deadline", "deal", "death", "debt", "debtor", "decade", "decimal", "decision", "decrease", "dedication", "deer", "defense", "deficit", "degree", "delete", "delivery", "den", "denim", "dentist", "deodorant", "deposit", "description", "desert", "design", "desire", "desk", "dessert", "destruction", "detail", "detective", "development", "dew", "diamond", "diaphragm", "dibble", "dictionary", "difference", "digestion", "digger", "digital", "dill", "dime", "dimple", "dinner", "dinosaur", "diploma", "direction", "dirt", "discovery", "discussion", "disease", "disgust", "dish", "distance", "distribution", "distributor", "diving", "division", "dock", "doctor", "dog", "dogsled", "doll", "dollar", "dolphin", "domain", "donkey", "door", "double", "doubt", "downtown", "dragon", "dragonfly", "drain", "drake", "drama", "draw", "drawbridge", "drawer", "dream", "dredger", "dress", "dresser", "dressing", "drill", "drink", "drive", "driver", "driving", "drizzle", "drop", "drug", "drum", "dryer", "duck", "duckling", "dugout", "dungeon", "dust", "eagle", "ear", "earth", "earthquake", "ease", "east", "edge", "edger", "editor", "editorial", "education", "eel", "effect", "egg", "eggnog", "eggplant", "eight", "elbow", "element", "elephant", "ellipse", "emery", "employee", "employer", "encyclopedia", "end", "enemy", "energy", "engine", "engineer", "engineering", "enquiry", "entrance", "environment", "epoch", "epoxy", "equinox", "equipment", "era", "estimate", "ethernet", "euphonium", "evening", "event", "examination", "example", "exchange", "exclamation", "exhaust", "existence", "expansion", "experience", "expert", "explanation", "eye", "eyebrow", "eyeliner", "face", "facilities", "fact", "factory", "fairies", "fall", "family", "fan", "fang", "farm", "farmer", "fat", "father", "faucet", "fear", "feast", "feather", "feature", "fedelini", "feedback", "feeling", "feet", "felony", "female", "fender", "ferry", "ferryboat", "fiber", "fiberglass", "fibre", "fiction", "field", "fifth", "fight", "fighter", "file", "find", "fine", "finger", "fir", "fire", "fireman", "fireplace", "firewall", "fish", "fisherman", "flag", "flame", "flare", "flat", "flavor", "flax", "flesh", "flight", "flock", "flood", "floor", "flower", "flugelhorn", "flute", "fly", "foam", "fog", "fold", "font", "food", "foot", "football", "footnote", "force", "forecast", "forehead", "forest", "forgery", "fork", "form", "format", "fortnight", "foundation", "fountain", "fowl", "fox", "foxglove", "fragrance", "frame", "freckle", "freeze", "freezer", "freighter", "freon", "friction", "friend", "frog", "front", "frost", "fruit", "fuel", "fur", "furniture", "galley", "gallon", "game", "gander", "garage", "garden", "garlic", "gas", "gasoline", "gate", "gateway", "gauge", "gazelle", "gear", "gearshift", "geese", "gender", "geography", "geology", "geometry", "geranium", "ghost", "giraffe", "girdle", "girl", "gladiolus", "glass", "glider", "gliding", "glockenspiel", "glove", "glue", "goal", "goat", "gold", "goldfish", "golf", "gondola", "gong", "goose", "gorilla", "gosling", "government", "governor", "grade", "grain", "gram", "granddaughter", "grandfather", "grandmother", "grandson", "grape", "graphic", "grass", "grasshopper", "gray", "grease", "green", "grenade", "grey", "grill", "grip", "ground", "group", "grouse", "growth", "guarantee", "guide", "guilty", "guitar", "gum", "gun", "gym", "gymnast", "hacksaw", "hail", "hair", "haircut", "halibut", "hall", "hallway", "hamburger", "hammer", "hamster", "hand", "handball", "handicap", "handle", "handsaw", "harbor", "hardboard", "hardcover", "hardhat", "hardware", "harmonica", "harmony", "harp", "hat", "hate", "hawk", "head", "headlight", "headline", "health", "hearing", "heart", "heat", "heaven", "hedge", "height", "helicopter", "helium", "hell", "helmet", "help", "hemp", "hen", "heron", "herring", "hexagon", "hill", "hip", "hippopotamus", "history", "hockey", "hoe", "hole", "holiday", "home", "honey", "hood", "hook", "hope", "horn", "horse", "hose", "hospital", "hot", "hour", "hourglass", "house", "hovercraft", "hub", "hubcap", "humidity", "humor", "hurricane", "hyacinth", "hydrant", "hydrofoil", "hydrogen", "hyena", "hygienic", "ice", "icebreaker", "icicle", "icon", "idea", "ikebana", "illegal", "imprisonment", "improvement", "impulse", "inch", "income", "increase", "index", "industry", "ink", "innocent", "input", "insect", "instruction", "instrument", "insulation", "insurance", "interactive", "interest", "interviewer", "intestine", "invention", "inventory", "invoice", "iris", "iron", "island", "jacket", "jaguar", "jail", "jam", "jar", "jasmine", "jaw", "jeans", "jeep", "jelly", "jellyfish", "jet", "jewel", "jogging", "join", "joke", "journey", "judge", "judo", "juice", "jumbo", "jump", "jumper", "jury", "justice", "jute", "kale", "kamikaze", "kangaroo", "karate", "kayak", "kendo", "ketchup", "kettle", "kettledrum", "key", "keyboard", "keyboarding", "kick", "kilogram", "kilometer", "kiss", "kitchen", "kite", "kitten", "kitty", "knee", "knickers", "knife", "knight", "knot", "knowledge", "kohlrabi", "laborer", "lace", "ladybug", "lake", "lamb", "lamp", "lan", "land", "landmine", "language", "larch", "lasagna", "latency", "latex", "lathe", "laugh", "laundry", "law", "lawyer", "layer", "lead", "leaf", "learning", "leather", "leek", "leg", "legal", "lemonade", "lentil", "lettuce", "level", "license", "lier", "lift", "light", "lightning", "lilac", "lily", "limit", "line", "linen", "link", "lion", "lip", "lipstick", "liquid", "liquor", "list", "literature", "litter", "liver", "lizard", "llama", "loaf", "loan", "lobster", "lock", "locket", "locust", "look", "loss", "lotion", "love", "low", "lumber", "lunch", "lunchroom", "lung", "lute", "luttuce", "lycra", "lynx", "lyocell", "lyre", "lyric", "macaroni", "machine", "macrame", "magazine", "magic", "maid", "mail", "mailbox", "mailman", "makeup", "male", "mall", "mallet", "man", "manager", "mandolin", "manicure", "map", "maple", "maraca", "marble", "margin", "marimba", "mark", "market", "mascara", "mask", "mass", "match", "math", "mattock", "mayonnaise", "meal", "measure", "meat", "mechanic", "medicine", "meeting", "melody", "memory", "men", "menu", "mercury", "message", "metal", "meteorology", "meter", "methane", "mice", "microwave", "middle", "mile", "milk", "milkshake", "millennium", "millimeter", "millisecond", "mimosa", "mind", "mine", "minibus", "minister", "mint", "minute", "mirror", "missile", "mist", "mistake", "mitten", "moat", "modem", "mole", "mom", "money", "monkey", "month", "moon", "morning", "mosque", "mosquito", "mother", "motion", "motorboat", "motorcycle", "mountain", "mouse", "moustache", "mouth", "move", "multimedia", "muscle", "museum", "music", "mustard", "nail", "name", "napkin", "nation", "neck", "need", "needle", "neon", "nephew", "nerve", "nest", "net", "network", "news", "newsprint", "newsstand", "nickel", "niece", "night", "nitrogen", "node", "noise", "noodle", "north", "nose", "note", "notebook", "notify", "novel", "number", "numeric", "nurse", "nut", "nylon", "oak", "oatmeal", "objective", "oboe", "observation", "occupation", "ocean", "ocelot", "octagon", "octave", "octopus", "odometer", "offence", "offer", "office", "oil", "okra", "olive", "onion", "open", "opera", "operation", "opinion", "option", "orange", "orchestra", "orchid", "order", "organ", "organisation", "organization", "ornament", "ostrich", "otter", "ounce", "output", "outrigger", "oval", "oven", "overcoat", "owl", "owner", "oxygen", "oyster", "packet", "page", "pail", "pain", "paint", "pair", "pajama", "pamphlet", "pan", "pancake", "pancreas", "panda", "pansy", "panther", "panties", "pantry", "pants", "panty", "pantyhose", "paper", "paperback", "parade", "parallelogram", "parcel", "parent", "parentheses", "park", "parrot", "parsnip", "particle", "partner", "partridge", "party", "passbook", "passenger", "passive", "pasta", "paste", "pastor", "pastry", "patch", "path", "patient", "patio", "payment", "pea", "peace", "peak", "peanut", "pear", "pelican", "pen", "penalty", "pencil", "pendulum", "pentagon", "peony", "pepper", "perch", "perfume", "period", "periodical", "peripheral", "permission", "person", "pest", "pet", "pharmacist", "pheasant", "philosophy", "phone", "piano", "piccolo", "pickle", "picture", "pie", "pig", "pigeon", "pike", "pillow", "pilot", "pimple", "pin", "pine", "ping", "pink", "pint", "pipe", "pizza", "place", "plain", "plane", "plant", "plantation", "plaster", "plasterboard", "plastic", "plate", "platinum", "playground", "playroom", "pleasure", "plier", "plot", "plough", "plow", "plywood", "pocket", "poet", "point", "poison", "police", "policeman", "polish", "pollution", "polo", "polyester", "pond", "popcorn", "poppy", "porch", "porcupine", "port", "porter", "position", "possibility", "postage", "postbox", "pot", "potato", "poultry", "pound", "powder", "power", "precipitation", "preface", "pressure", "price", "priest", "print", "printer", "prison", "probation", "process", "processing", "produce", "product", "production", "professor", "profit", "promotion", "propane", "property", "prose", "prosecution", "protest", "protocol", "pruner", "psychiatrist", "psychology", "ptarmigan", "puffin", "pull", "puma", "pump", "pumpkin", "punch", "punishment", "puppy", "purchase", "purple", "purpose", "push", "pyjama", "pyramid", "quail", "quality", "quart", "quarter", "quartz", "queen", "question", "quicksand", "quiet", "quill", "quilt", "quince", "quit", "quiver", "quotation", "rabbi", "rabbit", "racing", "radar", "radiator", "radio", "radish", "raft", "rail", "railway", "rain", "rainbow", "raincoat", "rainstorm", "rake", "ramie", "random", "range", "rat", "rate", "raven", "ravioli", "ray", "rayon", "reaction", "reading", "reason", "receipt", "recess", "record", "recorder", "rectangle", "red", "reduction", "refrigerator", "refund", "regret", "reindeer", "relation", "religion", "relish", "reminder", "repair", "replace", "report", "representative", "request", "resolution", "respect", "responsibility", "rest", "restaurant", "result", "retailer", "revolve", "revolver", "reward", "rhinoceros", "rhythm", "rice", "riddle", "rifle", "ring", "rise", "risk", "river", "riverbed", "road", "roadway", "roast", "robin", "rock", "rod", "roll", "roof", "room", "rooster", "root", "rose", "rotate", "route", "router", "rowboat", "rub", "rubber", "rugby", "run", "rutabaga", "sack", "sail", "sailboat", "sailor", "salad", "salary", "sale", "salesman", "salmon", "salt", "sampan", "samurai", "sand", "sandwich", "sardine", "satin", "sauce", "sausage", "save", "saw", "saxophone", "scale", "scallion", "scanner", "scarecrow", "scarf", "scene", "scent", "schedule", "school", "science", "scissors", "scooter", "scraper", "screw", "screwdriver", "sea", "seagull", "seal", "seaplane", "search", "seashore", "season", "seat", "second", "secret", "secretary", "secure", "security", "seed", "seeder", "segment", "select", "selection", "self", "semicircle", "semicolon", "sense", "sentence", "servant", "server", "session", "shade", "shadow", "shake", "shallot", "shame", "shampoo", "shape", "share", "shark", "shears", "sheep", "sheet", "shelf", "shell", "shield", "shingle", "ship", "shirt", "shock", "shoe", "shoemaker", "shop", "shorts", "shoulder", "shovel", "show", "shrimp", "shrine", "side", "sideboard", "sidecar", "sidewalk", "sign", "signature", "silica", "silk", "silver", "sing", "singer", "single", "sink", "sister", "size", "skate", "skiing", "skill", "skin", "skirt", "sky", "slash", "slave", "sled", "sleep", "sleet", "slice", "slip", "slippers", "slope", "smash", "smell", "smile", "smoke", "snail", "snake", "sneeze", "snow", "snowboarding", "snowflake", "snowman", "snowplow", "snowstorm", "soap", "soccer", "society", "sociology", "sock", "soda", "sofa", "softball", "softdrink", "software", "soldier", "son", "song", "soprano", "sound", "soup", "sousaphone", "soy", "soybean", "space", "spade", "spaghetti", "spandex", "spark", "sparrow", "spear", "specialist", "speedboat", "sphere", "spider", "spinach", "spleen", "sponge", "spoon", "spot", "spring", "sprout", "spruce", "spy", "square", "squash", "squid", "squirrel", "stage", "staircase", "stamp", "star", "start", "starter", "state", "statement", "station", "statistic", "steam", "steel", "stem", "step", "stepdaughter", "stepmother", "stepson", "stew", "stick", "stitch", "stock", "stocking", "stomach", "stone", "stool", "stop", "stopwatch", "store", "storm", "story", "stove", "stranger", "straw", "stream", "street", "streetcar", "stretch", "string", "structure", "study", "sturgeon", "submarine", "substance", "subway", "success", "suede", "sugar", "suggestion", "suit", "summer", "sun", "sundial", "sunflower", "supermarket", "supply", "support", "surfboard", "surgeon", "surname", "surprise", "sushi", "swallow", "swamp", "swan", "sweater", "sweatshirt", "sweatshop", "sweets", "swim", "swimming", "swing", "switch", "sword", "swordfish", "sycamore", "syrup", "system", "table", "tachometer", "tadpole", "tail", "tailor", "talk", "tank", "tanker", "target", "taste", "tax", "taxi", "taxicab", "tea", "teacher", "teaching", "teeth", "television", "teller", "temper", "temperature", "temple", "tempo", "tendency", "tennis", "tenor", "tent", "territory", "test", "text", "textbook", "texture", "theater", "theory", "thermometer", "thing", "thistle", "thought", "thread", "thrill", "throat", "throne", "thumb", "thunder", "thunderstorm", "ticket", "tie", "tiger", "tights", "tile", "time", "timer", "timpani", "tin", "tip", "tire", "titanium", "title", "toad", "toast", "toe", "toilet", "tomato", "ton", "tongue", "tooth", "toothbrush", "toothpaste", "top", "tornado", "tortellini", "tortoise", "touch", "tower", "town", "toy", "tractor", "trade", "traffic", "trail", "train", "tramp", "transaction", "transmission", "transport", "trapezoid", "tray", "treatment", "tree", "trial", "triangle", "trick", "trigonometry", "trip", "trombone", "trouble", "trousers", "trout", "trowel", "truck", "trumpet", "trunk", "tsunami", "tub", "tuba", "tugboat", "tulip", "tuna", "tune", "turn", "turnip", "turnover", "turret", "turtle", "twig", "twilight", "twine", "twist", "typhoon", "tyvek", "umbrella", "uncle", "underclothes", "underpants", "undershirt", "underwear", "unit", "utensil", "vacation", "vacuum", "valley", "value", "van", "vase", "vault", "vegetable", "veil", "vein", "velvet", "verdict", "vermicelli", "verse", "vessel", "vest", "vibraphone", "view", "vinyl", "viola", "violet", "violin", "viscose", "vise", "vision", "visitor", "voice", "volcano", "volleyball", "voyage", "vulture", "waiter", "waitress", "wall", "wallaby", "walrus", "war", "wash", "washer", "wasp", "waste", "watch", "watchmaker", "water", "waterfall", "wave", "wax", "way", "wealth", "weapon", "weasel", "weather", "wedge", "weeder", "week", "weight", "whale", "wheel", "whip", "whiskey", "whistle", "wholesaler", "whorl", "wilderness", "willow", "wind", "window", "windscreen", "windshield", "wine", "wing", "winter", "wire", "wish", "witness", "wolf", "women", "wood", "wool", "woolen", "work", "workshop", "worm", "wound", "wrecker", "wren", "wrench", "wrist", "writer", "xylophone", "yacht", "yam", "yard", "year", "yellow", "yew", "yogurt", "zebra", "zinc", "zone", "zoology" ]
    in
    Random.map
        (\index -> Maybe.withDefault "Error: Game has no words!" (Array.get index words))
        (Random.int 0 (Array.length words - 1))


randomRule : Random.Generator String
randomRule =
    Random.weighted
        -- Language 10% => 0.38%
        ( 10 / 26, "Use ONLY words that start with the letter T." )
        [ ( 10 / 26, "Use ONLY words that start with the letter O." )
        , ( 10 / 26, "Use ONLY words that start with the letter A." )
        , ( 10 / 26, "Use ONLY words that start with the letter W." )
        , ( 10 / 26, "Use ONLY words that start with the letter B." )
        , ( 10 / 26, "Use ONLY words that start with the letter F." )
        , ( 10 / 26, "Use ONLY words that start with the letter P." )
        , ( 10 / 26, "Use ONLY words that start with the letter K." )
        , ( 10 / 26, "Use ONLY words that start with the letter R." )
        , ( 10 / 26, "Use ONLY words that start with the letter N." )
        , ( 10 / 26, "Use ONLY words that do NOT contain the letter E." )
        , ( 10 / 26, "Use ONLY words that do NOT contain the letter T." )
        , ( 10 / 26, "Use ONLY words that do NOT contain the letter A." )
        , ( 10 / 26, "Use ONLY words that do NOT contain the letter O." )
        , ( 10 / 26, "Use ONLY words that do NOT contain the letter I." )
        , ( 10 / 26, "Use ONLY words that do NOT contain the letter N." )
        , ( 10 / 26, "Use ONLY words that do NOT contain the letter S." )
        , ( 10 / 26, "Use ONLY words that do NOT contain the letter R." )
        , ( 10 / 26, "Use ONLY words that rhyme with -ACK." )
        , ( 10 / 26, "Use ONLY words that rhyme with -AT." )
        , ( 10 / 26, "Use ONLY words that rhyme with -ATE." )
        , ( 10 / 26, "Use ONLY words that rhyme with -EET." )
        , ( 10 / 26, "Use ONLY words that rhyme with -ICK." )
        , ( 10 / 26, "Use ONLY words that rhyme with -IP." )
        , ( 10 / 26, "Use ONLY words that rhyme with -OON." )
        , ( 10 / 26, "Use ONLY words that rhyme with -UNK." )

        -- Senses 25% => 2.78%
        , ( 25 / 9, "Use ONLY COLOR words." )
        , ( 25 / 9, "Use ONLY SIZE words (like \"tall\" or \"slim\")." )
        , ( 25 / 9, "Use ONLY SHAPE words (like \"triangular\" or \"lopsided\")." )
        , ( 25 / 9, "Use ONLY TEXTURE words." )
        , ( 25 / 9, "Use ONLY ACTION words (like \"jump\")." )
        , ( 25 / 9, "Use ONLY SMELL words." )
        , ( 25 / 9, "Use ONLY TASTE words." )
        , ( 25 / 9, "Use ONLY EMOTION words." )
        , ( 25 / 9, "Use ONLY WEIGHT words (like \"heavy\" or 32kg)." )

        -- Silly 35% => 3.89%
        , ( 35 / 9, "Can ONLY POINT at things." )
        , ( 35 / 9, "Use ONLY HAND motions." )
        , ( 35 / 9, "Can ONLY SING song LYRICS." )
        , ( 35 / 9, "Use ONLY SOUND EFFECTS." )
        , ( 35 / 9, "Can ONLY DRAW in the AIR." )
        , ( 35 / 9, "Use ONLY your EYES to POINT at things." )
        , ( 35 / 9, "Freestyle a RAP that RHYMES." )
        , ( 35 / 9, "Can ONLY WHALESPEAK (each word must take 5 seconds)." )
        , ( 35 / 9, "Must KEEP lips CLOSED while speaking." )

        -- Participation 19% => 3.8%
        , ( 19 / 5, "Use ANY word, but just ONE." )
        , ( 19 / 5, "Can ONLY say YES or NO." )
        , ( 19 / 5, "Can ONLY say WARMER or COOLER." )
        , ( 19 / 5, "Say ANYTHING, but your team gets ONLY ONE guess." )
        , ( 19 / 5, "Can ONLY ask your team QUESTIONS." )

        -- Knowledge 11% => 2.2%
        , ( 11 / 5, "Use ONLY types of WEATHER (like \"rainy\")." )
        , ( 11 / 5, "Use ONLY NUMBERS (like 17 or 3.14)." )
        , ( 11 / 5, "Use ONLY PLACES or LOCATIONS (like Hawaii)" )
        , ( 11 / 5, "Use ONLY \"A is to B as C is to ___\" statements." )
        , ( 11 / 5, "Use ONLY \"___ is a type of ___\" statements." )
        ]



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- HISTORY TYPE
-- Helps to reduce repeated elements in the drawing of random rules.


type alias History =
    { one : String
    , two : String
    , three : String
    , four : String
    , five : String
    }


pushHistory : String -> History -> History
pushHistory newRule h =
    History newRule h.one h.two h.three h.four


historyIncludes : String -> History -> Bool
historyIncludes rule h =
    rule == h.one || rule == h.two || rule == h.three || rule == h.four || rule == h.five



-- MODEL


type alias Model =
    { showInstructions : Bool
    , word : String
    , rule : String
    , timeRemaining : Int
    , score1 : Int
    , score2 : Int
    , ruleHistory : History
    }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model False "???" "???" 0 0 0 (History "" "" "" "" ""), Cmd.none )



-- UPDATE


type Msg
    = GetNewWord
    | NewWord String
    | GetNewRule
    | NewRule String
    | NewTime Time.Posix
    | IncrementScore1
    | DecrementScore1
    | IncrementScore2
    | DecrementScore2
    | ResetScores
    | ShowInstructions
    | HideInstructions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNewWord ->
            ( model, Random.generate NewWord randomWord )

        NewWord newWord ->
            ( { model | word = newWord }, Cmd.none )

        GetNewRule ->
            ( { model | timeRemaining = timeLimit }, Random.generate NewRule randomRule )

        NewRule newRule ->
            if historyIncludes newRule model.ruleHistory then
                ( model, Random.generate NewRule randomRule )

            else
                ( { model | rule = newRule, ruleHistory = pushHistory newRule model.ruleHistory }, Cmd.none )

        NewTime _ ->
            let
                timeRemaining =
                    model.timeRemaining

                newModel =
                    { model | timeRemaining = timeRemaining - 1 }
            in
            if timeRemaining == 1 then
                ( newModel, playSfx (E.bool True) )

            else
                ( newModel, Cmd.none )

        IncrementScore1 ->
            ( { model | score1 = normalizeScore 0 winScore (model.score1 + 1) }, Cmd.none )

        DecrementScore1 ->
            ( { model | score1 = normalizeScore 0 winScore (model.score1 - 1) }, Cmd.none )

        IncrementScore2 ->
            ( { model | score2 = normalizeScore 0 winScore (model.score2 + 1) }, Cmd.none )

        DecrementScore2 ->
            ( { model | score2 = normalizeScore 0 winScore (model.score2 - 1) }, Cmd.none )

        ResetScores ->
            ( { model | score1 = 0, score2 = 0 }, Cmd.none )

        ShowInstructions ->
            ( { model | showInstructions = True }, Cmd.none )

        HideInstructions ->
            ( { model | showInstructions = False }, Cmd.none )



-- UPDATE HELPERS: SCORE


normalizeScore : Int -> Int -> Int -> Int
normalizeScore minScore maxScore score =
    if score < minScore then
        minScore

    else if score > maxScore then
        maxScore

    else
        score



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 NewTime



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Nonsense"
    , body =
        [ main_ [ class "app" ]
            [ audio [ id "alarm-audio", src "/sounds/alarm.mp3", controls False ] []
            , viewInstructions model
            , viewWord model
            , viewRule model
            , viewScore model
            ]
        ]
    }



-- VIEW COMPONENTS


viewInstructions : Model -> Html Msg
viewInstructions model =
    if model.showInstructions then
        div [ class "instructions" ]
            [ button [ onClick HideInstructions ] [ text "Hide" ]
            , ul []
                [ li [] [ text "Game requires 4 or more players and 1 phone. Make 2 teams and pick 1 clue giver from each team." ]
                , li [] [ text "Together, clue givers draw a single shared word (tap the \"New word\" button) unknown to their teams. Each round teams will compete to guess the word. Clue givers may NEVER explicitly communicate the word. Also, clue givers may skip words until they agree on one." ]
                , li [] [ text "Now, clue givers and their teams will take 45 second turns trying to figure out the word." ]
                , li [] [ text "At the start of each turn, the current clue giver draws a new clue-giving rule (tap the \"New rule\" button) and announces the rule. Clue givers may skip 1 rule per turn." ]
                , li [] [ text "This clue giver must give clues to their team obeying the rule and only this clue giver's team may try to guess the word. A team can make unlimited guesses within the 45 second turn. Also, all clues given should be perceivable to both teams." ]
                , li [] [ text "If a rule is ever broken or the word communicated explicitly, the team at fault must forfeit 1 point to the other team." ]
                , li [] [ text "After 45 seconds, the turn ends and it is the other clue giver and team's turn to give clues and guess the word. Remember, the other clue giver should begin their turn by drawing a new clue-giving rule." ]
                , li [] [ text "The first team to guess the word wins 1 point and ends the round." ]
                , li [] [ text "However, if neither team can guess the word after 3 clues are given by each clue giver, the game enters Blitz Mode: Both clue givers may communicate without restriction (though they still CANNOT communicate the word explicitly) and both teams may guess at any time without restriction. The first team to guess the word wins the point." ]
                , li [] [ text "After a round ends, each team must pick 1 new clue giver and the losing team gets to start the next round. The new clue givers must pick a new word to guess for the next round." ]
                , li [] [ text "The first team to 7 points wins." ]
                ]
            ]

    else
        div [ class "instructions" ] [ button [ onClick ShowInstructions ] [ text "How to play?" ] ]


viewWord : Model -> Html Msg
viewWord model =
    div [ class "word" ]
        [ h1 [] [ text "Word" ]
        , p [ class "word-text" ] [ text model.word ]
        , button [ onClick GetNewWord ] [ text "New word" ]
        ]


viewRule : Model -> Html Msg
viewRule model =
    if model.timeRemaining > 0 then
        div [ class "rule" ]
            [ h1 [] [ text <| "Rule • " ++ String.fromInt model.timeRemaining ++ "s left" ]
            , p [ class "rule-text" ] [ text model.rule ]
            , button [ onClick GetNewRule ] [ text "New rule" ]
            ]

    else
        div [ class "rule" ]
            [ h1 [] [ text "Rule" ]
            , p [ class "rule-text" ] [ text "???" ]
            , button [ onClick GetNewRule ] [ text "New rule" ]
            ]


viewScore : Model -> Html Msg
viewScore model =
    div [ class "score" ]
        [ if model.score1 >= winScore then
            h1 [] [ text "Score • Team 1 wins!" ]

          else if model.score2 >= winScore then
            h1 [] [ text "Score • Team 2 wins!" ]

          else
            h1 [] [ text "Score" ]
        , p []
            [ span [ class "score-label" ] [ text "Team 1: " ]
            , button [ onClick DecrementScore1 ] [ text "–" ]
            , span [ class "score-value" ] [ text <| " " ++ String.fromInt model.score1 ++ " " ]
            , button [ onClick IncrementScore1 ] [ text "+" ]
            ]
        , p []
            [ span [ class "score-label" ] [ text "Team 2: " ]
            , button [ onClick DecrementScore2 ] [ text "–" ]
            , span [ class "score-value" ] [ text <| " " ++ String.fromInt model.score2 ++ " " ]
            , button [ onClick IncrementScore2 ] [ text "+" ]
            ]
        , button [ onClick ResetScores ] [ text "Reset scores" ]
        ]
