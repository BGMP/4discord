# A module which catalogs and maps all 4chan's boards's names and features
#

BOARDS = {
    :a      =>    "animemanga",
    :c      =>    "animecute",
    :w      =>    "animewallpapers",
    :m      =>    "mecha",
    :cgl    =>    "cosplay",
    :cm     =>    "cutemale",
    :n      =>    "teletransportation",
    :jp     =>    "otaku",
    :v      =>    "videogames",
    :vg     =>    "videogamesgeneral",
    :vm     =>    "multiplayer",
    :vmg    =>    "mobile",
    :vp     =>    "pokemon",
    :vr     =>    "retrogames",
    :vrpg   =>    "rpg",
    :vst    =>    "strategy",
    :co     =>    "comics",
    :g      =>    "technology",
    :tv     =>    "television",
    :k      =>    "weapons",
    :o      =>    "auto",
    :an     =>    "animals",
    :tg     =>    "traditionalgames",
    :sp     =>    "sports",
    :asp    =>    "alternativesports",
    :sci    =>    "science",
    :his    =>    "history",
    :int    =>    "international",
    :out    =>    "outdoors",
    :toy    =>    "toys",
    :i      =>    "oekaki",
    :po     =>    "origami",
    :p      =>    "photography",
    :ck     =>    "cooking",
    :ic     =>    "artwork",
    :wg     =>    "wallpapers",
    :lit    =>    "literature",
    :mu     =>    "music",
    :fa     =>    "fashion",
    "3"     =>    "3dcg",
    :gd     =>    "graphicdesign",
    :diy    =>    "doityourself",
    :wsg    =>    "worksafegif",
    :qst    =>    "quests",
    :biz    =>    "business",
    :trv    =>    "travel",
    :fit    =>    "fitness",
    :x      =>    "paranormal",
    :adv    =>    "advice",
    :lgbt   =>    "lgbt",
    :mlp    =>    "pony",
    :news   =>    "news",
    :wsr    =>    "worksaferequests",
    :vip    =>    "veryimportantposts",
    :b      =>    "random",
    :r9k    =>    "robot9001",
    :pol    =>    "politicallyincorrect",
    :bant   =>    "internationalrandom",
    :soc    =>    "meetups",
    :s4s    =>    "shit4chansays",
    :s      =>    "sexy",
    :hc     =>    "hardcore",
    :hm     =>    "handsome",
    :h      =>    "hentai",
    :e      =>    "ecchi",
    :u      =>    "yuri",
    :d      =>    "hentaialternative",
    :y      =>    "yaoi",
    :t      =>    "torrents",
    :hr     =>    "highresolution",
    :gif    =>    "adultgif",
    :aco    =>    "adultcartoons",
    :r      =>    "adultrequests",
}.freeze

module ChanBoards
  class << self

    # Converts the passed board name into its board slug equivalent. (i.e: Random => b)
    # If the passed name happens to already be the slug, such as "b", it will just return itself.
    #
    # @param name The name of the board
    # @return The slug corresponding to the passed board name
    def name_to_board_slug(name)
      key = name.downcase
      if BOARDS.has_key?(key.to_sym) or BOARDS.has_key?(key.to_s)
        name
      else
        slug = BOARDS.key(key)
        slug.nil? ? nil : slug.to_s
      end
    end
  end
end
