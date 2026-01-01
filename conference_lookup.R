# Conference assignments for all D1 MBB teams (2025-26 season)
# Based on ESPN standings page

conference_lookup <- data.frame(
  Team = c(
    # America East
    "UMBC Retrievers", "Vermont Catamounts", "NJIT Highlanders", "UMass Lowell River Hawks",
    "New Hampshire Wildcats", "Bryant Bulldogs", "Binghamton Bearcats", "UAlbany Great Danes",
    "Maine Black Bears",
    
    # American
    "Temple Owls", "Tulsa Golden Hurricane", "North Texas Mean Green", "Tulane Green Wave",
    "UAB Blazers", "Florida Atlantic Owls", "South Florida Bulls", "Wichita State Shockers",
    "Rice Owls", "Memphis Tigers", "East Carolina Pirates", "UTSA Roadrunners", "Charlotte 49ers",
    
    # ASUN
    "Austin Peay Governors", "Lipscomb Bisons", "West Georgia Wolves", "Florida Gulf Coast Eagles",
    "North Alabama Lions", "Bellarmine Knights", "Central Arkansas Bears", "Jacksonville Dolphins",
    "Queens University Royals", "Eastern Kentucky Colonels", "Stetson Hatters", "North Florida Ospreys",
    
    # Atlantic 10
    "Duquesne Dukes", "George Mason Patriots", "Saint Louis Billikens", "St. Bonaventure Bonnies",
    "Richmond Spiders", "Dayton Flyers", "Fordham Rams", "George Washington Revolutionaries",
    "Rhode Island Rams", "VCU Rams", "Saint Joseph's Hawks", "La Salle Explorers",
    "Loyola Chicago Ramblers", "Davidson Wildcats",
    
    # ACC
    "North Carolina Tar Heels", "Miami Hurricanes", "Louisville Cardinals", "Notre Dame Fighting Irish",
    "Duke Blue Devils", "Virginia Cavaliers", "SMU Mustangs", "Virginia Tech Hokies",
    "Clemson Tigers", "Georgia Tech Yellow Jackets", "NC State Wolfpack", "Syracuse Orange",
    "Wake Forest Demon Deacons", "Boston College Eagles", "California Golden Bears", "Stanford Cardinal",
    "Florida State Seminoles", "Pittsburgh Panthers",
    
    # Big 12
    "Arizona Wildcats", "Iowa State Cyclones", "BYU Cougars", "Houston Cougars",
    "Oklahoma State Cowboys", "UCF Knights", "Baylor Bears", "Colorado Buffaloes",
    "Kansas Jayhawks", "TCU Horned Frogs", "Texas Tech Red Raiders", "Arizona State Sun Devils",
    "Kansas State Wildcats", "West Virginia Mountaineers", "Cincinnati Bearcats", "Utah Utes",
    
    # Big East
    "Creighton Bluejays", "UConn Huskies", "Villanova Wildcats", "St. John's Red Storm",
    "Seton Hall Pirates", "Xavier Musketeers", "Georgetown Hoyas", "Butler Bulldogs",
    "DePaul Blue Demons", "Providence Friars", "Marquette Golden Eagles",
    
    # Big Sky
    "Northern Colorado Bears", "Idaho Vandals", "Portland State Vikings", "Idaho State Bengals",
    "Montana Grizzlies", "Montana State Bobcats", "Northern Arizona Lumberjacks", "Weber State Wildcats",
    "Sacramento State Hornets", "Eastern Washington Eagles",
    
    # Big South
    "High Point Panthers", "Charleston Southern Buccaneers", "Longwood Lancers", "South Carolina Upstate Spartans",
    "Winthrop Eagles", "Presbyterian Blue Hose", "Radford Highlanders", "UNC Asheville Bulldogs",
    "Gardner-Webb Runnin' Bulldogs",
    
    # Big Ten
    "Nebraska Cornhuskers", "Michigan Wolverines", "Michigan State Spartans", "Purdue Boilermakers",
    "UCLA Bruins", "Illinois Fighting Illini", "Washington Huskies", "Minnesota Golden Gophers",
    "USC Trojans", "Iowa Hawkeyes", "Indiana Hoosiers", "Ohio State Buckeyes",
    "Wisconsin Badgers", "Penn State Nittany Lions", "Northwestern Wildcats", "Maryland Terrapins",
    "Oregon Ducks", "Rutgers Scarlet Knights",
    
    # Big West
    "Hawai'i Rainbow Warriors", "UC Santa Barbara Gauchos", "UC Irvine Anteaters", "UC San Diego Tritons",
    "UC Riverside Highlanders", "Cal State Northridge Matadors", "Cal Poly Mustangs", "UC Davis Aggies",
    "Cal State Bakersfield Roadrunners", "Cal State Fullerton Titans", "Long Beach State Beach",
    
    # CAA
    "UNC Wilmington Seahawks", "William & Mary Tribe", "Hofstra Pride", "Elon Phoenix",
    "Charleston Cougars", "Hampton Pirates", "Monmouth Hawks", "North Carolina A&T Aggies",
    "Stony Brook Seawolves", "Towson Tigers", "Campbell Fighting Camels", "Drexel Dragons",
    "Northeastern Huskies",
    
    # CUSA
    "Liberty Flames", "New Mexico State Aggies", "Louisiana Tech Bulldogs", "Middle Tennessee Blue Raiders",
    "Missouri State Bears", "Jacksonville State Gamecocks", "Kennesaw State Owls", "Sam Houston Bearkats",
    "Florida International Panthers", "Western Kentucky Hilltoppers", "Delaware Blue Hens", "UTEP Miners",
    
    # Horizon
    "Milwaukee Panthers", "Detroit Mercy Titans", "Wright State Raiders", "Oakland Golden Grizzlies",
    "Purdue Fort Wayne Mastodons", "Northern Kentucky Norse", "Robert Morris Colonials", "Youngstown State Penguins",
    "Green Bay Phoenix", "Cleveland State Vikings", "IU Indianapolis Jaguars",
    
    # Ivy
    "Yale Bulldogs", "Columbia Lions", "Harvard Crimson", "Cornell Big Red",
    "Pennsylvania Quakers", "Brown Bears", "Dartmouth Big Green", "Princeton Tigers",
    
    # MAAC
    "Quinnipiac Bobcats", "Saint Peter's Peacocks", "Merrimack Warriors", "Siena Saints",
    "Marist Red Foxes", "Manhattan Jaspers", "Iona Gaels", "Sacred Heart Pioneers",
    "Mount St. Mary's Mountaineers", "Canisius Golden Griffins", "Niagara Purple Eagles", "Fairfield Stags",
    "Rider Broncs",
    
    # MAC
    "Miami (OH) RedHawks", "Buffalo Bulls", "Akron Zips", "Kent State Golden Flashes",
    "Toledo Rockets", "Northern Illinois Huskies", "Bowling Green Falcons", "Eastern Michigan Eagles",
    "Ohio Bobcats", "Ball State Cardinals", "Massachusetts Minutemen", "Western Michigan Broncos",
    "Central Michigan Chippewas",
    
    # MEAC
    "Howard Bison", "Norfolk State Spartans", "Delaware State Hornets", "North Carolina Central Eagles",
    "Maryland Eastern Shore Hawks", "Morgan State Bears", "Coppin State Eagles", "South Carolina State Bulldogs",
    
    # MVC
    "Illinois State Redbirds", "Murray State Racers", "Bradley Braves", "Northern Iowa Panthers",
    "Belmont Bruins", "Indiana State Sycamores", "Drake Bulldogs", "Valparaiso Beacons",
    "UIC Flames", "Southern Illinois Salukis", "Evansville Purple Aces",
    
    # Mountain West
    "Utah State Aggies", "Nevada Wolf Pack", "San Diego State Aztecs", "Grand Canyon Lopes",
    "UNLV Rebels", "Boise State Broncos", "New Mexico Lobos", "Wyoming Cowboys",
    "Colorado State Rams", "Fresno State Bulldogs", "San José State Spartans", "Air Force Falcons",
    
    # NEC
    "Central Connecticut Blue Devils", "Long Island University Sharks", "Wagner Seahawks", "Le Moyne Dolphins",
    "Mercyhurst Lakers", "New Haven Chargers", "Fairleigh Dickinson Knights", "Stonehill Skyhawks",
    "Chicago State Cougars", "Saint Francis Red Flash",
    
    # OVC
    "Lindenwood Lions", "Morehead State Eagles", "Tennessee State Tigers", "Eastern Illinois Panthers",
    "UT Martin Skyhawks", "SIU Edwardsville Cougars", "Southeast Missouri State Redhawks", "Little Rock Trojans",
    "Tennessee Tech Golden Eagles", "Western Illinois Leathernecks", "Southern Indiana Screaming Eagles",
    
    # Patriot
    "Navy Midshipmen", "American University Eagles", "Army Black Knights", "Colgate Raiders",
    "Boston University Terriers", "Holy Cross Crusaders", "Lehigh Mountain Hawks", "Loyola Maryland Greyhounds",
    "Bucknell Bison", "Lafayette Leopards",
    
    # SEC
    "Vanderbilt Commodores", "Georgia Bulldogs", "LSU Tigers", "Alabama Crimson Tide",
    "Arkansas Razorbacks", "Missouri Tigers", "Oklahoma Sooners", "Tennessee Volunteers",
    "Texas A&M Aggies", "Auburn Tigers", "Florida Gators", "Kentucky Wildcats",
    "South Carolina Gamecocks", "Texas Longhorns", "Ole Miss Rebels", "Mississippi State Bulldogs",
    
    # Southern
    "East Tennessee State Buccaneers", "Furman Paladins", "Mercer Bears", "Wofford Terriers",
    "Samford Bulldogs", "Chattanooga Mocs", "VMI Keydets", "Western Carolina Catamounts",
    "UNC Greensboro Spartans", "The Citadel Bulldogs",
    
    # Southland
    "Stephen F. Austin Lumberjacks", "Nicholls Colonels", "McNeese Cowboys", "New Orleans Privateers",
    "Incarnate Word Cardinals", "Texas A&M-Corpus Christi Islanders", "UT Rio Grande Valley Vaqueros", "Lamar Cardinals",
    "East Texas A&M Lions", "Northwestern State Demons", "SE Louisiana Lions", "Houston Christian Huskies",
    
    # SWAC
    "Alabama A&M Bulldogs", "Grambling Tigers", "Prairie View A&M Panthers", "Southern Jaguars",
    "Florida A&M Rattlers", "Alabama State Hornets", "Arkansas-Pine Bluff Golden Lions", "Bethune-Cookman Wildcats",
    "Texas Southern Tigers", "Alcorn State Braves", "Jackson State Tigers", "Mississippi Valley State Delta Devils",
    
    # Summit
    "St. Thomas-Minnesota Tommies", "North Dakota State Bison", "South Dakota Coyotes", "Denver Pioneers",
    "Omaha Mavericks", "South Dakota State Jackrabbits", "North Dakota Fighting Hawks", "Oral Roberts Golden Eagles",
    "Kansas City Roos",
    
    # Sun Belt
    "Arkansas State Red Wolves", "Georgia Southern Eagles", "Troy Trojans", "Georgia State Panthers",
    "App State Mountaineers", "Coastal Carolina Chanticleers", "Texas State Bobcats", "Southern Miss Golden Eagles",
    "South Alabama Jaguars", "Old Dominion Monarchs", "Louisiana Ragin' Cajuns", "Marshall Thundering Herd",
    "James Madison Dukes", "UL Monroe Warhawks",
    
    # WCC
    "Gonzaga Bulldogs", "Saint Mary's Gaels", "Santa Clara Broncos", "Oregon State Beavers",
    "San Francisco Dons", "Seattle U Redhawks", "Loyola Marymount Lions", "San Diego Toreros",
    "Washington State Cougars", "Pacific Tigers", "Portland Pilots", "Pepperdine Waves",
    
    # WAC
    "Utah Valley Wolverines", "Tarleton State Texans", "Utah Tech Trailblazers", "Abilene Christian Wildcats",
    "California Baptist Lancers", "UT Arlington Mavericks", "Southern Utah Thunderbirds"
  ),
  Conference = c(
    # America East (9)
    rep("America East", 9),
    
    # American (13)
    rep("American", 13),
    
    # ASUN (12)
    rep("ASUN", 12),
    
    # Atlantic 10 (14)
    rep("Atlantic 10", 14),
    
    # ACC (18)
    rep("ACC", 18),
    
    # Big 12 (16)
    rep("Big 12", 16),
    
    # Big East (11)
    rep("Big East", 11),
    
    # Big Sky (10)
    rep("Big Sky", 10),
    
    # Big South (9)
    rep("Big South", 9),
    
    # Big Ten (18)
    rep("Big Ten", 18),
    
    # Big West (11)
    rep("Big West", 11),
    
    # CAA (13)
    rep("CAA", 13),
    
    # CUSA (12)
    rep("CUSA", 12),
    
    # Horizon (11)
    rep("Horizon", 11),
    
    # Ivy (8)
    rep("Ivy", 8),
    
    # MAAC (13)
    rep("MAAC", 13),
    
    # MAC (13)
    rep("MAC", 13),
    
    # MEAC (8)
    rep("MEAC", 8),
    
    # MVC (11)
    rep("MVC", 11),
    
    # Mountain West (12)
    rep("Mountain West", 12),
    
    # NEC (10)
    rep("NEC", 10),
    
    # OVC (11)
    rep("OVC", 11),
    
    # Patriot (10)
    rep("Patriot", 10),
    
    # SEC (16)
    rep("SEC", 16),
    
    # Southern (10)
    rep("Southern", 10),
    
    # Southland (12)
    rep("Southland", 12),
    
    # SWAC (12)
    rep("SWAC", 12),
    
    # Summit (9)
    rep("Summit", 9),
    
    # Sun Belt (14)
    rep("Sun Belt", 14),
    
    # WCC (12)
    rep("WCC", 12),
    
    # WAC (7)
    rep("WAC", 7)
  ),
  stringsAsFactors = FALSE
)

# Verify count
cat(sprintf("Total teams in conference lookup: %d\n", nrow(conference_lookup)))