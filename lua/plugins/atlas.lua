return {
	-- "emrearmagan/atlas.nvim",
	-- branch = "dev",
	dir = "/Users/jannes.muense/Projects/nvim/atlas.nvim/",
	event = "VeryLazy",
	config = function()
		local function open_live_command(title, cmd, on_exit)
			local min_width = 40
			local min_height = 12
			local width = math.max(min_width, math.floor(vim.o.columns * 0.2))
			local height = math.max(min_height, math.floor(vim.o.lines * 0.25))
			local row = math.floor((vim.o.lines - height) / 2) - 1
			local col = math.floor((vim.o.columns - width) / 2)
			local buf = vim.api.nvim_create_buf(false, true)
			vim.bo[buf].bufhidden = "wipe"
			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				style = "minimal",
				border = "rounded",
				title = " " .. title .. " ",
				title_pos = "center",
				width = width,
				height = height,
				row = math.max(0, row),
				col = math.max(0, col),
			})
			vim.keymap.set("n", "q", function()
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end
			end, { buffer = buf, silent = true })
			vim.fn.jobstart(cmd, {
				term = true,
				on_exit = function(_, code, _)
					vim.schedule(function()
						if on_exit then
							on_exit(code)
						end
					end)
				end,
			})
		end

		require("atlas").setup({
			pulls = {
				diff = {
					open_cmd = "DiffviewOpen",
				},
				repo_config = {
					settings = {
						["check24/zzv*"] = {
							readme = "README.md",
						},
					},
					paths = {
						["check24/zzv-frontend"] = "~/Projects/zzv/zzv-frontend",
						["check24/zzv-api"] = "~/Projects/zzv/zzv-api",
						["check24/zzv-core"] = "~/Projects/zzv/zzv-core",
						["check24/zzv-cypress"] = "~/Projects/zzv/zzv-cypress",
						["check24/vv-ham-app-ios-zzv"] = "~/development/app/check24.C24Zzv/",
						["check24/vv-ham-app-ios-hh-shared"] = "~/development/app/check24.C24HHShared/",
					},
				},

				custom_actions = {
					{
						id = "checkout_worktree",
						label = "Checkout (worktrees)",

						---@param _ PullRequest
						---@param ctx AtlasPullsCustomActionContext
						---@param done fun(ok: boolean|nil, message: string|nil)
						run = function(_, ctx, done)
							if not ctx.repo_path then
								done(false, "No repo path")
								return
							end

							local branch = tostring(ctx.pr.source.branch or "")
							if branch == "" then
								done(false, "Missing source branch")
								return
							end

							local destination = ctx.repo_path .. ".worktrees"

							open_live_command("worktrees-review", {
								"worktrees-review",
								branch,
								destination,
								ctx.repo_path,
								"--split=h",
								"--session=worktrees",
							}, function(code)
								if code ~= 0 then
									done(false, "worktrees failed (exit " .. tostring(code) .. ")")
									return
								end
								done(true, "Worktree ready for " .. branch)
							end)
						end,
					},
					{
						id = "code_review_worktree",
						label = "Code Review",

						---@param _ PullRequest
						---@param ctx AtlasPullsCustomActionContext
						---@param done fun(ok: boolean|nil, message: string|nil)
						run = function(_, ctx, done)
							if not ctx.repo_path then
								done(false, "No repo path")
								return
							end

							local branch = tostring(ctx.pr.source.branch or "")
							if branch == "" then
								done(false, "Missing source branch")
								return
							end

							local destination = ctx.repo_path .. ".reviews"

							open_live_command("worktrees-review", {
								"worktrees-review",
								branch,
								destination,
								ctx.repo_path,
								"--skip-unchanged",
							}, function(code)
								if code ~= 0 then
									done(false, "worktrees-review failed (exit " .. tostring(code) .. ")")
									return
								end
								done(true, "Code review started for " .. branch)
							end)
						end,
					},
				},
				providers = {
					bitbucket = {
						user = os.getenv("BITBUCKET_USER") or "",
						token = os.getenv("BITBUCKET_TOKEN") or "",
						cache_ttl = 300,

						---@type AtlasBitbucketViewConfig[]
						views = {
							{
								name = "Me",
								key = "1",
								layout = "compact",
								repos = {
									{ workspace = "check24", repo = "zzv-frontend" },
									{ workspace = "check24", repo = "zzv-core" },
									{ workspace = "check24", repo = "zzv-api" },
									{ workspace = "check24", repo = "zzv-cypress" },
									{ workspace = "check24", repo = "vv-ham-app-ios-hh-shared" },
									{ workspace = "check24", repo = "vv-ham-app-ios-zzv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-gkv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-rv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-hhw" },
								},

								---@param pr PullRequest
								---@param ctx { user: PullsUser|nil }
								filter = function(pr, ctx)
									local user = ctx.user or {}
									return pr.author and pr.author.id == user.id
								end,
							},
							{
								name = "Team",
								key = "2",
								layout = "plain",
								repos = {
									{ workspace = "check24", repo = "zzv-frontend" },
									{ workspace = "check24", repo = "zzv-core" },
									{ workspace = "check24", repo = "zzv-api" },
									{ workspace = "check24", repo = "zzv-cypress" },
									{ workspace = "check24", repo = "vv-ham-app-ios-hh-shared" },
									{ workspace = "check24", repo = "vv-ham-app-ios-zzv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-gkv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-rv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-hhw" },
								},

								---@param pr PullRequest
								---@param ctx { user: PullsUser  }
								filter = function(pr, ctx)
									local user = ctx.user or {}
									return pr.author and pr.author.id ~= user.id
								end,
							},
							{
								name = "App",
								key = "3",
								layout = "plain",
								repos = {
									{ workspace = "check24", repo = "vv-ham-app-ios-hh-shared" },
									{ workspace = "check24", repo = "vv-ham-app-ios-zzv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-gkv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-rv" },
									{ workspace = "check24", repo = "vv-ham-app-ios-hhw" },
								},
							},
						},
					},
				},
			},

			issues = {
				fetch_parent_issues = true,
				max_result = 200,
				custom_actions = {
					{
						id = "jira_review_opencode",
						label = "Review with OpenCode",

						---@param issue Issue
						---@param _ AtlasIssuesCustomActionContext
						---@param done fun(ok: boolean|nil, message: string|nil)
						run = function(issue, _, done)
							local issue_key = tostring(issue.key or "")
							if issue_key == "" then
								done(false, "Missing issue key")
								return
							end

							local issue_summary = tostring(issue.summary or "")
							vim.fn.jobstart({ "jira-review", issue_key, issue_summary }, {
								on_exit = function(_, code, _)
									vim.schedule(function()
										if code ~= 0 then
											done(false, "jira-review failed (exit " .. tostring(code) .. ")")
											return
										end
										done(true, "Jira review opened in tmux for " .. issue_key)
									end)
								end,
							})
						end,
					},
				},

				providers = {
					---@type AtlasJiraIssuesConfig
					jira = {
						base_url = os.getenv("JIRA_BASE_URL") or "",
						email = os.getenv("JIRA_EMAIL") or "",
						token = os.getenv("JIRA_TOKEN") or "",
						cache_ttl = 300,

						project_config = {
							["ZAHN"] = {
								customfield_10105 = {
									name = "PR Status",
									format = function(value)
										return value.content[1].content[1].text
									end,
									hl_group = "AtlasJiraChipStoryPoints",
								},
								customfield_10020 = {
									name = "Sprint",
									format = function(value)
										if not value or not value[1] then
											return nil
										end
										return value[1].name
									end,
									hl_group = "AtlasTextMuted",
									display = "table",
								},
								watches = {
									name = "Watchers",
									format = function(value)
										if not value then
											return nil
										end
										return "󰈈 " .. value.watchCount
									end,
									hl_group = "AtlasJiraChipStoryPoints",
								},

								attachment = {
									name = "Attachments",
									format = function(value)
										if not value or #value == 0 then
											return nil
										end

										return string.format("%s %s", "", tostring(#value))
									end,
									hl_group = "AtlasJiraChipStoryPoints",
								},
							},
						},
						projects = {
							["ZAHN"] = {
								story_point_field = "customfield_10035",
								custom_fields = {
									{ key = "customfield_10016", label = "Acceptance Criteriaa" },
								},
							},
						},

						views = {
							{
								name = "My Tasks",
								key = "1",
								jql = "project = ZAHN AND assignee = currentUser() AND statusCategory != Done ORDER BY status ASC, assignee ASC, updated DESC",
							},
							{
								name = "Epic",
								key = "2",
								jql = '"Epic Link" = ZAHN-8885 ORDER BY status ASC, assignee ASC, updated DESC',
							},
							{
								name = "To Do",
								key = "3",
								jql = 'project = ZAHN AND sprint in openSprints() AND statusCategory = "To Do" AND assignee is EMPTY ORDER BY priority ASC',
							},
							{
								name = "Spring",
								key = "4",
								jql = "project = ZAHN AND sprint in openSprints() ORDER BY priority ASC",
							},
						},
					},
				},
			},
		})
	end,
}
