defmodule TurboXmlTest do
  use ExUnit.Case, async: true
  doctest TurboXml
  import TurboXml

  test "turbo xml" do
    xml = doc do
      node "n1" do
        "text1"
      end
    end
    assert :erlang.iolist_to_binary(xml) === "<?xml version=\"1.0\"?><n1>text1</n1>"
  end

  test "dynamic turbo xml" do
    xml = doc do
      node "root" do
        for x <- 1..3 do
          node "n#{x}" do
            "t#{x}"
          end
        end
      end
    end
    assert :erlang.iolist_to_binary(xml) ===
      "<?xml version=\"1.0\"?><root><n1>t1</n1><n2>t2</n2><n3>t3</n3></root>"
  end

  test "node body nil handling" do
    xml = doc do
      node "nilTest" do end
    end
    xml_bin = :erlang.iolist_to_binary(xml)
    assert xml_bin === "<?xml version=\"1.0\"?><nilTest></nilTest>"
  end

  test "bad xml" do
    xml = node "bad" do
      "<iambad&&\"yo'>"
    end
    xml_bin = :erlang.iolist_to_binary(xml)
    assert xml_bin === "<bad>&lt;iambad&amp;&amp;&quot;yo&apos;&gt;</bad>"
  end

  test "atom node name" do
    xml = node :node do end
    xml_bin = :erlang.iolist_to_binary(xml)
    assert xml_bin === "<node></node>"
  end

  test "xml attributes" do
    xml = node "node", id: "me!", class: "ftou" do  end
    xml_bin = :erlang.iolist_to_binary(xml)
    assert xml_bin === "<node id=\"me!\" class=\"ftou\"></node>"
  end
end