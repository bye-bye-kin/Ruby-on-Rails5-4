投稿の編集をするための投稿編集ページを作成していきます

投稿を編集するには、①編集したい投稿を取得し、②その投稿のcontentの値を上書きした後に、③データベースに保存します。
post.content = "新しい値"とすることで、投稿のcontentの値を上書きすることができます。

$ rails console
＞post=Post.find_by(id:1) ①編集したい投稿を取得
＞post.content="にゃーん"　　　②その投稿のcontentの値を上書き
＞post.save　　　　　　　　　③データベースに保存します


###################################################################################################################

投稿を削除する
①削除したい投稿を取得し
②その投稿に対してdestroyメソッドを用いる

$ rails console
＞post=Post.find_by(id:2)
＞post.destroy

###################################################################################################################

投稿編集機能を作る。
→まずは投稿編集用のページを用意しよう。
（新しくページを作る場合にはルーティング、アクション、ビューを用意する）

#/config/routes.rb(ルーティング)
<div class="post-menus">
<%= link_to("編集", "/posts/#{@post.id}/edit") %>
</div>

#./controllers/posts_controller.rb（アクション）
def edit
end

#/posts/edit.html.erb（ビュー）


################################################################################################################

編集内容を入力できるフォームを作る

まず初期値を設定する。
「<textarea>初期値</「>」のようにタグで囲んだ部分を初期値として設定できます。

フォームの初期値として、編集したい投稿内容を表示しましょう。
editアクションで、①URLのidと同じidの投稿データをデータベースから取得し、そのcontentの値（＝投稿の内容）を初期値に設定します。

#./controllers/posts_controller.rb ←①
def edit
    @post = Post.find_by(id: params[:id])
  end

#/posts/edit.html.erb ←②
<textarea><%= @post.content%></textarea>

#################################################################################################################

入力内容を受け取るためのアクションを用意しよう。

update アクションには以下の機能をつける。
・フォームの内容の保存
・投稿一覧画面への転送
まずは投稿一覧画面へ転送する機能をつけよう。

updateアクションの用意
※updateアクションはフォームの値を受け取るので、ルーティングをgetではなく、postにする必要があります。
また、特定のidの投稿を更新するので、URLにidを含むようにしましょう。
投稿を編集した後は投稿一覧ページにリダイレクトさせるので、ビューは
不要です。

フォームの送信先の指定
フォームで入力した内容をデータベースに保存するためには、フォームのデータをupdateアクションに送信する必要があります。
新規投稿ページを作ったときと同様に、form_tagメソッドを用いて、送信先を指定しましょう。


というわけでフォームから入力内容を受け取るために
①ルーティング
②アクション
③form_tag
を定義しましょう。

#/config/routes.rb(①ルーティング)
post "posts/:id/update"=>"posts#update"

#./controllers/posts_controller.rb(②アクション)
def update
    redirect_to("/posts/index")
end
#./controllers/posts_controller.(③ビューでform_tagの設定)
<%= form_tag("/posts/#{@post.id}/update") do %>
      <div class="form">
        <div class="form-body">
          <textarea><%= @post.content %></textarea>
          <input type="submit" value="保存">
        </div>
      </div>
    <!-- endを追加してください -->
  # <% end %>


###################################################################################################################

投稿の内容を更新する

①URLに含まれるidを用いて、データベースから投稿データを取得する
②フォームから編集内容を受け取り、投稿データを更新する
<textarea>タグにname属性を指定し、フォームの入力内容が変数paramsに代入されてupdateアクションに送信されるようにします。
updateアクションでは、フォームから送信された値をparams[:content]で
受け取り、@post.content = params[:content]で投稿データの内容を更新します。

#./posts/edit.html.erb ←①
<textarea name="content"><%= @post.content %></textarea> #フォームから送信された値をparams[:content]で受け取るようにする

#/controllers/posts_controller.rb　←②
def update
    @post=Post.find_by(id :params[:id])　#URLのidから、投稿データを取得する。
    @post.content=params[:content]       #取得した投稿データのcontentの値を上書きする。
    @post.save                           #上書きした投稿データを保存する。   
    
    redirect_to("/posts/index")
  end

###############################################################################################################

投稿を削除する

destroyアクションのルーティングはgetではなくpostにします。
URLのidから削除したい投稿を特定できるように「posts/:id/destroy」とURLの中にidを含むことに注意しましょう。

destroy アクションには以下の機能をつける。
・投稿の削除
・投稿一覧画面への転送

#<getとpostの違い>
#get:　データベースを変更しないアクション
#post:　データベースを変更するアクション

①まずはルーティングから
#/config/routes.rb
post "posts/:id/destroy"=>"posts#destroy"

②で、アクション
#./controllers/posts_controller.rb
def destroy
    redirect_to("/posts/index")
    
end 

#################################################################################################################

post用のリンク

link_toの第三引数に「{method: "post"}」を追加することで、「post」として定義されているルーティングに
マッチするようになります。

##<%= link_to("削除", "/posts/#{@post.id}/destroy",{method:"post"}) %>

#################################################################################################################

データベースから取り出して削除するアクション

def destroy
    # destroyアクションの中身を作成してください
    @post=Post.find_by(id: params[:id])
    @post.destroy
    
    redirect_to("/posts/index")
  end

