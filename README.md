# 个人探索企业微信 Codex 网关

这是一个与 `wecom-codex-gateway` 完全独立的个人探索机器人，用于个人学习、学习项目、部署项目、个人兴趣和其他探索。它使用独立的 Codex 工作目录、SQLite 数据库、企业微信凭证和端口，不读取或修改 `/mnt/e/Project/LMK/工作档案/`。

## 独立边界

- 服务代码：`/mnt/e/Project/LMK/personal-exploration-gateway`
- Codex 工作空间：`/mnt/e/Project/LMK/个人探索工作空间`
- 档案目录：`个人探索工作空间/个人探索档案/`
- 数据库：`data/personal-exploration-bot.db`
- 凭证：`~/.config/personal-exploration-wecom-gateway/bot.env`
- 端口：`8788`（原工作机器人是 `8787`）

个人探索机器人只应绑定一个新的企业微信智能机器人 BotID/Secret。不要复用工作机器人凭证；同一个 BotID 不能同时建立两条长连接。

## 初次安装

```bash
cd /mnt/e/Project/LMK/personal-exploration-gateway
python3 -m venv .venv
.venv/bin/python -m ensurepip --upgrade
.venv/bin/python -m pip install -r requirements-dev.txt
chmod +x scripts/*.sh scripts/*.py
```

## 先本地验证（不连接企业微信）

```bash
cd /mnt/e/Project/LMK/personal-exploration-gateway
./scripts/start-mock.sh
```

另开终端验证：

```bash
cd /mnt/e/Project/LMK/personal-exploration-gateway
.venv/bin/python scripts/simulate.py '/帮助' --base-url http://127.0.0.1:8788
.venv/bin/python scripts/simulate.py '/任务' --base-url http://127.0.0.1:8788
curl http://127.0.0.1:8788/healthz
```

## 连接新的企业微信智能机器人

在企业微信手机端创建一个新的“API 模式”智能机器人，选择“使用长连接”，可见范围先限制为自己，取得新的 BotID 和 Secret。然后运行：

```bash
cd /mnt/e/Project/LMK/personal-exploration-gateway
./scripts/setup-bot.sh
./scripts/start-bot.sh
```

`setup-bot.sh` 会隐藏输入 Secret，并保存到 `~/.config/personal-exploration-wecom-gateway/bot.env`（目录 700、文件 600）。启动日志出现 `authenticated` 和 `Application startup complete` 后，在新机器人中发送 `/帮助`。

健康检查：

```bash
curl http://127.0.0.1:8788/healthz
curl http://127.0.0.1:8788/readyz
```

## 可用命令

`/帮助`、`/状态`、`/继续`、`/新建 [主题]`、`/总结`、`/任务`、`/记录 内容`、`/取消`。直接发送文字会在个人探索线程中继续分析。

进度会集中在一个企业微信流式消息中，只展示公开阶段摘要，不展示隐藏思维链、原始命令输出或密钥。

## 运行方式

停止服务时，在运行窗口按 `Ctrl+C`。不要在两个终端同时启动同一个个人探索 BotID。原工作机器人仍按原项目的 `./scripts/start-bot.sh` 启动，使用 `8787` 和另一套凭证。
