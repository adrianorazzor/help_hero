defmodule HelpHeroWeb.WebhookControllerTest do
  use HelpHeroWeb.ConnCase

  import HelpHero.WebhooksFixtures

  alias HelpHero.Webhooks.Webhook

  @create_attrs %{
    message: "some message",
    sender: "some sender"
  }
  @update_attrs %{
    message: "some updated message",
    sender: "some updated sender"
  }
  @invalid_attrs %{message: nil, sender: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all webhooks", %{conn: conn} do
      conn = get(conn, ~p"/api/webhooks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create webhook" do
    test "renders webhook when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/webhooks", webhook: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/webhooks/#{id}")

      assert %{
               "id" => ^id,
               "message" => "some message",
               "sender" => "some sender"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/webhooks", webhook: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update webhook" do
    setup [:create_webhook]

    test "renders webhook when data is valid", %{conn: conn, webhook: %Webhook{id: id} = webhook} do
      conn = put(conn, ~p"/api/webhooks/#{webhook}", webhook: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/webhooks/#{id}")

      assert %{
               "id" => ^id,
               "message" => "some updated message",
               "sender" => "some updated sender"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, webhook: webhook} do
      conn = put(conn, ~p"/api/webhooks/#{webhook}", webhook: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete webhook" do
    setup [:create_webhook]

    test "deletes chosen webhook", %{conn: conn, webhook: webhook} do
      conn = delete(conn, ~p"/api/webhooks/#{webhook}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/webhooks/#{webhook}")
      end
    end
  end

  defp create_webhook(_) do
    webhook = webhook_fixture()
    %{webhook: webhook}
  end
end
