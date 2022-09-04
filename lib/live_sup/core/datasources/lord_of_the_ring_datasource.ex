defmodule LiveSup.Core.Datasources.LordOfTheRingDatasource do
  @moduledoc """
    This datasource returns a quote from a hardcoded list. It does not
    perform any external request
  """
  def get_quote do
    quotes()
    |> Jason.decode!()
    |> Enum.random()
    |> parse()
  end

  defp parse(item) do
    %{
      quote: item["quote"],
      author: item["author"]
    }
  end

  defp quotes do
    """
    [
      {
          "quote": "Many that live deserve death. And some that die deserve life. Can you give it to them? Then do not be too eager to deal out death in judgement. For even the very wise cannot see all ends.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "All we have to decide is what to do with the time that is given to us.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Seldom give unguarded advice, for advice is a dangerous gift, even from the wise to the wise, and all courses may run ill.",
          "author": "Gildor Inglorion",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Some things are ill to hear when the world's in shadow.",
          "author": "Tom Bombadil",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Don't adventures ever have an end? I suppose not. Someone else always has to carry on the story.",
          "author": "Bilbo Baggins",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "He that breaks a thing to find out what it is has left the path of wisdom.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Even the most subtle spiders may leave a weak thread.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "It is perilous to study too deeply the arts of the Enemy, for good or for ill.",
          "author": "Elrond",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Oft in lies truth is hidden.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Valour needs first strength, and then a weapon.",
          "author": "Boromir",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Those who made [the three elven rings of power] did not desire strength or domination or hoarded wealth, but understanding, making, and healing, to preserve all things unstained.",
          "author": "Elrond",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Such is oft the course of deeds that move the wheels of the world: small hands do them because they must, while the eyes of the great are elsewhere.",
          "author": "Elrond",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Only a small part is played in great deeds by any hero.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Faithless is he that says farewell when the road darkens. ",
          "author": "Gimli",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Let him not vow to walk in the dark, who has not seen the nightfall.",
          "author": "Elrond",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "In nothing is the power of the Dark Lord more clearly shown than in the estrangement that divides all those who still oppose him.",
          "author": "Haldir",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "The world is indeed full of peril, and in it there are many dark places; but still there is much that is fair, and though in all lands love is now mingled with grief, it grows perhaps the greater.",
          "author": "Haldir",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Do not trouble your hearts overmuch with thought of the road tonight. Maybe the paths that you each shall tread are already laid before your feet, though you do not see them.",
          "author": "Galadriel",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Do not despise the lore that has come down from distant years; for oft it may chance that old wives keep in memory word of things that once were needful for the wise to know.",
          "author": "Celeborn",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Do not cast all hope away. Tomorrow is unkown. Rede oft is found at the rising of the Sun.",
          "author": "Legolas",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "There are some things that it is better to begin than to refuse, even though the end may be dark.",
          "author": "Aragorn",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "A treacherous weapon is ever a danger to the hand.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "News from afar is seldom sooth.",
          "author": "King Theoden",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "The wise speak only of what they know.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "To crooked eyes truth may wear a wry face.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Oft the unbidden guest proves the best company.",
          "author": "Eomer",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "None knows what the new day shall bring him. ",
          "author": "Aragorn",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "One who cannot cast away a treasure at need is in fetters.",
          "author": "Aragorn",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "The treacherous are ever distrustful.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "One cannot be both tyrant and counselor.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Often does hatred hurt itself!",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Things will go as they will; and there is no need to hurry to meet them.",
          "author": "Treebeard",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Oft evil will shall evil mar.",
          "author": "King Theoden",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Perilous to us all are the devices of an art deeper than we possess ourselves.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "The burned hand teaches best. After that advice about fire goes to the heart.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Better mistrust undeserved than rash words.",
          "author": "Frodo",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Fair speech may hide a foul heart.",
          "author": "Sam Gamgee",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "The praise of the praiseworthy is above all rewards.",
          "author": "Faramir",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Generous deed should not be checked by cold counsel.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "The hasty stroke goes oft astray.",
          "author": "Aragorn",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Deeds will not be less valiant because they are unpraised.",
          "author": "Aragorn",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Where will wants not, a way opens.",
          "author": "Dernhelm",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "A traitor may betray himself and do good that he does not intend.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Hope oft deceives. ... Yet twice blessed is help unlooked for.",
          "author": "Eomer",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "Follow what may, great deeds are not lessened in worth.",
          "author": "Legolas",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "It needs but one foe to breed a war, not two.... And those who have not swords can still die upon them. Would you have the folk of Gondor gather you herbs only, when the Dark Lord gathers armies?",
          "author": "Eowyn",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "It is not always good to be healed in body. Nor is it always evil to die in battle, even in bitter pain.",
          "author": "Eowyn",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "It is useless to meet revenge with revenge: it will heal nothing.",
          "author": "Frodo",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "It must often be so, Sam, when things are in danger: some one has to give them up, lose them, so that others may keep them.",
          "author": "Frodo",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      },
      {
          "quote": "I will not say: do not weep; for not all tears are an evil.",
          "author": "Gandalf",
          "source": "The Lord of the Rings",
          "tags": null,
          "public": "yes"
      }
    ]
    """
  end
end
