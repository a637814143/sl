<template>
  <div class="mini-app">
    <header class="status-bar">8am 实验室 · 清晨饮品站</header>
    <main class="content">
      <section v-if="activeTab === 'home'" class="panel home-panel">
        <template v-if="isAdmin">
          <div class="admin-request-board">
            <header class="section-header">
              <div>
                <h2>商家账号申请</h2>
                <p class="section-desc">新的商家账号需管理员审核后才能登录。</p>
              </div>
              <div class="request-summary">
                <article class="request-summary-card">
                  <p class="card-label">待审批</p>
                  <strong>{{ merchantApprovalStats.pending }}</strong>
                  <small>当前排队</small>
                </article>
                <article class="request-summary-card">
                  <p class="card-label">今日新增</p>
                  <strong>{{ merchantApprovalStats.today }}</strong>
                  <small>今日提交</small>
                </article>
                <article class="request-summary-card">
                  <p class="card-label">累计申请</p>
                  <strong>{{ merchantApprovalStats.total }}</strong>
                  <small>历史记录</small>
                </article>
              </div>
            </header>

            <div v-if="merchantRequestsLoading" class="store-empty">正在加载申请...</div>
            <p class="feedback" v-if="merchantRequestsError">{{ merchantRequestsError }}</p>
            <ul class="request-list" v-else-if="pendingMerchantRequests.length">
              <li v-for="request in pendingMerchantRequests" :key="request.id">
                <div>
                  <strong>{{ request.merchantName }}</strong>
                  <p class="request-meta">
                    申请人：{{ request.applicant }} · {{ request.phone }} · {{ request.submittedAt }}
                  </p>
                  <p class="request-meta">{{ request.location }}</p>
                  <small>{{ request.note || '暂无备注' }}</small>
                </div>
                <div class="request-actions">
                  <button
                    class="ghost"
                    type="button"
                    :disabled="merchantRequestProcessing === request.id"
                    @click="handleRejectMerchantRequest(request)"
                  >
                    驳回
                  </button>
                  <button
                    class="primary"
                    type="button"
                    :disabled="merchantRequestProcessing === request.id"
                    @click="handleApproveMerchantRequest(request)"
                  >
                    同意
                  </button>
                </div>
              </li>
            </ul>
            <div v-else class="store-empty">暂无新的商家账号申请。</div>

            <section class="history-list" v-if="processedMerchantRequests.length">
              <h3>最近处理</h3>
              <ul>
                <li v-for="request in processedMerchantRequests" :key="request.id">
                  <div>
                    <p>{{ request.merchantName }}</p>
                    <small>{{ request.applicant }} · {{ request.processedAt || request.submittedAt }}</small>
                  </div>
                  <span class="status-pill" :class="request.status === 'APPROVED' ? 'success' : 'pending'">
                    {{ request.status === 'APPROVED' ? '已同意' : '已驳回' }}
                  </span>
                </li>
              </ul>
            </section>
          </div>
        </template>
        <template v-else-if="!isMerchant">
          <article class="store-gate" :class="{ empty: !selectedMerchant }">
            <div>
              <p class="card-label">{{ selectedMerchant ? '当前门店' : '选择门店' }}</p>
              <h2>{{ selectedMerchant?.name || '请选择取餐门店' }}</h2>
              <small>
                {{
                  selectedMerchant?.location || '不同门店每日上新不同，请先锁定门店以查看对应菜单。'
                }}
              </small>
            </div>
            <button class="primary" type="button" @click="openStorePicker">
              {{ selectedMerchant ? '切换门店' : '立即选择' }}
            </button>
          </article>
          <template v-if="selectedMerchant">
            <HomeShowcase
              :drinks="productLibrary"
              :banners="storefrontBanners"
              :merchants="merchants"
              :cart-items="sharedCartItems"
              :cart-summary="sharedCartSummary"
              :cart-total="sharedCartTotal"
              :add-to-cart="addCartItem"
              :increment-item="addCartItem"
              :decrement-item="decrementCartItem"
              :clear-cart="clearSharedCart"
              @checkout="enterCheckout"
            />
          </template>
          <div v-else class="store-gate-empty">
            <p>请选择门店后即可浏览今日菜单和推荐。</p>
            <button class="ghost" type="button" @click="openStorePicker">选择门店</button>
          </div>
        </template>
        <template v-else>
          <div class="merchant-home">
            <section class="merchant-carousel-card">
              <header class="section-header">
                <div>
                  <h2>轮播管理</h2>
                  <p class="section-desc">设置顾客端首页顶部轮播，宣传主打活动与新品。</p>
                </div>
                <small>最多 5 张，建议 750×360 像素</small>
              </header>
              <div v-if="merchantCarouselLoading" class="store-empty">轮播图加载中...</div>
              <div v-else-if="!merchantCarousel.length" class="store-empty">暂无轮播图片，快来上传吧。</div>
              <div v-else class="carousel-grid">
                <article v-for="banner in merchantCarousel" :key="banner.id" class="carousel-card">
                  <div class="carousel-thumb" :style="{ backgroundImage: `url(${banner.imageUrl})` }"></div>
                  <strong>{{ banner.caption || '主视觉' }}</strong>
                  <button class="ghost" type="button" @click="removeCarouselItem(banner.id)">移除</button>
                </article>
              </div>
              <div class="menu-add">
                <input v-model="newCarousel.imageUrl" type="url" placeholder="图片地址" />
                <input v-model="newCarousel.caption" type="text" placeholder="标题 / 副标题" />
                <input type="file" accept="image/*" capture="environment" @change="handleCarouselImageUpload" />
                <small class="upload-hint" v-if="carouselImageUploading">图片上传中...</small>
                <small class="upload-hint" v-else-if="newCarousel.imageUrl">已上传，可生成轮播。</small>
                <div class="image-preview" v-if="newCarousel.imageUrl">
                  <img :src="newCarousel.imageUrl" alt="轮播图预览" />
                </div>
                <button class="primary" type="button" :disabled="!newCarousel.imageUrl" @click="addCarouselItem">
                  新增轮播
                </button>
              </div>
              <p class="feedback" v-if="merchantHomeNotice">{{ merchantHomeNotice }}</p>
            </section>

            <section class="merchant-recommend-card">
              <header class="section-header">
                <div>
                  <h2>今日推荐</h2>
                  <p class="section-desc">对应顾客端首页四个专区，快速配置今日推荐饮品。</p>
                </div>
                <button class="ghost" type="button" @click="syncRecommendationsFromMenu">沿用上架商品</button>
              </header>
              <div class="recommend-grid">
                <article v-for="slot in recommendationSlots" :key="slot.key">
                  <p class="card-label">{{ slot.label }}</p>
                  <select
                    v-model="merchantRecommendations[slot.key]"
                    :disabled="!(recommendationOptionsBySlot[slot.key]?.length)"
                  >
                    <option value="">选择饮品</option>
                    <option
                      v-for="drink in recommendationOptionsBySlot[slot.key] || []"
                      :key="`${slot.key}-${drink.id}`"
                      :value="drink.name"
                    >
                      {{ drink.name }}
                    </option>
                  </select>
                  <small>{{ merchantRecommendations[slot.key] ? '已同步至顾客端' : '尚未设置' }}</small>
                </article>
              </div>
            </section>

            <section class="merchant-home-actions">
              <header class="section-header">
                <div>
                  <h2>快速操作</h2>
                  <p class="section-desc">进入工作台或通知顾客当日变化。</p>
                </div>
              </header>
              <div class="action-grid">
                <button class="primary" type="button" @click="activeTab = 'order'">打开工作台 · 管理商品</button>
                <button class="ghost" type="button" @click="announceStatus">发送营业状态通知</button>
              </div>
            </section>
          </div>
        </template>
      </section>

      <section v-else-if="activeTab === 'order' && showWorkbench" class="panel">
        <template v-if="!currentUser">
          <div class="empty-state">
            <h2>请先登录</h2>
            <p>登录后即可根据角色进入对应的工作台。</p>
          </div>
        </template>
        <template v-else-if="isAdmin">
          <div class="admin-workbench">
            <header class="panel-header admin-hero">
              <div>
                <p class="eyebrow">科学化管理</p>
                <h1 class="heading">8AM 运营驾驶舱</h1>
                <p class="subheading">实时掌握饮品、订单、门店与会员动态，守护品牌体验。</p>
              </div>
              <div class="admin-meta">
                <p>当前账号</p>
                <strong>{{ currentUser?.displayName || currentUser?.username }}</strong>
                <small>{{ roleLabel(currentUser?.role) }}</small>
              </div>
            </header>

            <nav class="admin-subtabs">
              <button
                v-for="tab in adminPanels"
                :key="tab.key"
                type="button"
                :class="{ active: adminActivePanel === tab.key }"
                @click="adminActivePanel = tab.key"
              >
                <span class="icon">{{ tab.icon }}</span>
                <div>
                  <strong>{{ tab.label }}</strong>
                  <small>{{ tab.desc }}</small>
                </div>
              </button>
            </nav>

            <section v-if="adminActivePanel === 'overview'" class="admin-section">
              <div class="dashboard-grid admin-kpi-grid">
                <article
                  v-for="card in adminKpis"
                  :key="card.label"
                  class="dashboard-card"
                  :class="{ highlight: card.highlight }"
                >
                  <p class="card-label">{{ card.label }}</p>
                  <strong>{{ card.value }}</strong>
                  <span>{{ card.desc }}</span>
                </article>
              </div>
              <div class="dashboard-secondary">
                <article class="timeline-card">
                  <header>
                    <p class="card-label">数据流程</p>
                    <small>实时状态</small>
                  </header>
                  <ul class="pipeline">
                    <li v-for="stage in adminPipeline" :key="stage.label">
                      <div class="pipeline-head">
                        <strong>{{ stage.value }}</strong>
                        <span>{{ stage.label }}</span>
                      </div>
                      <p>{{ stage.desc }}</p>
                      <div class="pipeline-bar">
                        <span :style="{ width: stage.ratio + '%' }"></span>
                      </div>
                    </li>
                  </ul>
                </article>
                <article class="insight-card compact">
                  <header>
                    <p class="card-label">今日焦点</p>
                    <small>自动巡检</small>
                  </header>
                  <h3 class="insight-title">{{ adminFocus.title }}</h3>
                  <p class="insight-desc">{{ adminFocus.desc }}</p>
                </article>
              </div>
              <div class="order-hints">
                <p>{{ adminAutomationHint }}</p>
              </div>
            </section>

            <section v-else class="admin-section">
              <header class="section-header merchants-header">
                <div>
                  <h2>账号与门店</h2>
                  <p class="section-desc">集中处理门店资料、账号权限与入驻审核。</p>
                </div>
                <div class="section-actions">
                  <button class="primary" type="button" @click="openAdminManager('merchants')">打开商家管理</button>
                  <button class="ghost" type="button" @click="openAdminManager('accounts')">账号管理</button>
                </div>
              </header>

              <article class="admin-callout">
                <p class="card-label">统一入口</p>
                <h3>所有账号操作均已迁移至「灵感 · 账号管理」</h3>
                <p>顾客、商家、管理员账号分组展示，可直接完成增删改查。</p>
                <ul>
                  <li>顾客账号：会员、体验官与体验资格</li>
                  <li>商家账号：门店、设备与运营伙伴</li>
                  <li>管理员账号：总部协作与审批权限</li>
                </ul>
              </article>

              <section class="admin-summary-grid">
                <article>
                  <p class="card-label">待审批</p>
                  <strong>{{ merchantApprovalStats.pending }}</strong>
                  <small>商家入驻申请</small>
                </article>
                <article>
                  <p class="card-label">今日新增</p>
                  <strong>{{ merchantApprovalStats.today }}</strong>
                  <small>今日提交</small>
                </article>
                <article>
                  <p class="card-label">累计申请</p>
                  <strong>{{ merchantApprovalStats.total }}</strong>
                  <small>历史记录</small>
                </article>
              </section>

              <section class="request-preview" v-if="merchantRequestPreview.length">
                <header>
                  <div>
                    <h3>最新待处理</h3>
                    <p>优先跟进最近 3 条门店申请。</p>
                  </div>
                  <button class="ghost" type="button" @click="openAdminManager('accounts')">去审批</button>
                </header>
                <ul>
                  <li v-for="request in merchantRequestPreview" :key="request.id">
                    <div>
                      <strong>{{ request.merchantName }}</strong>
                      <p>{{ request.location }}</p>
                    </div>
                    <div class="request-meta">
                      <span>{{ request.applicant }}</span>
                      <small>{{ request.submittedAt }}</small>
                    </div>
                  </li>
                </ul>
              </section>
              <div class="store-empty" v-else>暂无待审批门店，请继续维护已上线商家。</div>
            </section>

            <p class="feedback admin-feedback" v-if="adminCommandFeedback">{{ adminCommandFeedback }}</p>
          </div>
        </template>
        <template v-else-if="isMerchant">
          <div class="merchant-workbench">
            <section class="merchant-status-card">
              <header>
                <div>
                  <p class="card-label">今日门店</p>
                  <h1 class="heading">{{ merchantSnapshot?.merchantName || '我的门店' }}</h1>
                  <p class="subheading">掌握今日目标、库存与营业状态。</p>
                </div>
                <div class="status-select">
                  <label>营业状态</label>
                  <select v-model="merchantStatus">
                    <option v-for="option in merchantStatusOptions" :key="option.value" :value="option.value">
                      {{ option.label }}
                    </option>
                  </select>
                </div>
              </header>
              <div class="status-note">
                <label>营业提示</label>
                <textarea
                  v-model="merchantStatusNote"
                  rows="2"
                  placeholder="例：因培训 14:00-15:00 暂停接单"
                ></textarea>
              </div>
              <ul class="status-metrics">
                <li>
                  <p class="card-label">今日目标</p>
                  <strong>{{ menuStats.target }}</strong>
                  <small>计划总量</small>
                </li>
                <li>
                  <p class="card-label">已售数量</p>
                  <strong>{{ menuStats.sold }}</strong>
                  <small>含线上订单</small>
                </li>
                <li>
                  <p class="card-label">剩余可售</p>
                  <strong>{{ menuStats.remaining }}</strong>
                  <small>售罄自动提醒</small>
                </li>
                <li>
                  <p class="card-label">接单状态</p>
                  <strong>{{ merchantStatusLabel }}</strong>
                  <small>{{ merchantAlerts }}</small>
                </li>
              </ul>
            </section>

            <section class="merchant-menu-card">
              <header class="section-header">
                <div>
                  <h2>今日商品上架</h2>
                  <p class="section-desc">按门店情况灵活调整份数、时间段与上下架。</p>
                </div>
              </header>
              <div class="menu-controls">
                <div class="bulk-actions">
                  <button class="ghost" type="button" @click="hydrateDailyMenu">沿用昨日菜单</button>
                  <button class="ghost" type="button" @click="clearDailyMenu" :disabled="!dailyMenu.length">
                    清空今日菜单
                  </button>
                </div>
                <div class="menu-toolbar">
                  <input
                    class="menu-search"
                    v-model="menuSearch"
                    type="search"
                    placeholder="搜索商品或甜品"
                  />
                  <label class="menu-toggle">
                    <input type="checkbox" v-model="menuShowSelectedOnly" />
                    <span>仅看已上架</span>
                  </label>
                </div>
                <small class="menu-tip">
                  展开品类即可上架，直接输入份数，顶部实时计算今日目标。
                </small>
              </div>
              <div class="menu-accordion" v-if="productLibrary.length">
                <article v-for="category in productCategories" :key="category.value" class="menu-panel">
                  <header @click="toggleMenuPanel(category.value)">
                    <div>
                      <strong>{{ category.label }}</strong>
                      <small>{{ category.desc }}</small>
                    </div>
                    <button class="ghost icon-only" type="button">
                      {{ menuPanelState[category.value] ? '收起' : '展开' }}
                    </button>
                  </header>
                  <transition name="accordion">
                    <div v-show="menuPanelState[category.value]" class="menu-panel-body scrollable">
                      <div
                        v-if="filteredMenuBuckets[category.value]?.length"
                        class="menu-grid compact"
                      >
                        <article
                          v-for="item in filteredMenuBuckets[category.value]"
                          :key="item.id"
                          class="menu-card selectable compact"
                          :class="{ selected: isInDailyMenu(item.id) }"
                        >
                          <div class="mini-row">
                            <strong>{{ item.name }}</strong>
                            <button class="ghost mini" type="button" @click="toggleDailyMenuItem(item)">
                              {{ isInDailyMenu(item.id) ? '取消' : '加入' }}
                            </button>
                          </div>
                          <div class="mini-row meta">
                            <label>
                              档期
                              <select v-model="menuDraftById[item.id].slot">
                                <option v-for="slot in menuSlots" :key="slot.value" :value="slot.value">
                                  {{ slot.label }}
                                </option>
                              </select>
                            </label>
                            <label>
                              份数
                              <input
                                v-model.number="menuDraftById[item.id].target"
                                type="number"
                                min="5"
                                step="5"
                              />
                            </label>
                          </div>
                        </article>
                      </div>
                      <small
                        class="menu-scroll-hint"
                        v-if="filteredMenuBuckets[category.value]?.length > 4"
                      >
                        向下滑动查看更多
                      </small>
                      <p class="empty-tip" v-else>该品类暂无符合条件的商品。</p>
                    </div>
                  </transition>
                </article>
              </div>
              <div class="menu-grid" v-else>
                <p class="empty-tip">尚未上架任何商品，请先在“商品库”新增。</p>
              </div>
              <div class="menu-grid" v-if="dailyMenu.length">
                <article v-for="item in dailyMenu" :key="item.id" class="menu-card">
                  <header>
                    <strong>{{ item.name }}</strong>
                    <span class="menu-status" :class="item.status.toLowerCase()">
                      {{ item.status === 'ACTIVE' ? '可售' : '暂停' }}
                    </span>
                  </header>
                  <p class="menu-slot">时间档：{{ slotLabel(item.slot) }}</p>
                  <div class="menu-progress">
                    <div class="bar">
                      <span :style="{ width: menuProgress(item) + '%' }"></span>
                    </div>
                    <small>{{ item.sold }} / {{ item.target }} {{ menuUnitLabel(item) }}</small>
                  </div>
                  <ul class="menu-meta">
                    <li>剩余：{{ Math.max(item.target - item.sold, 0) }} {{ menuUnitLabel(item) }}</li>
                    <li>状态：{{ item.status === 'ACTIVE' ? '正常售卖' : '暂停' }}</li>
                  </ul>
                  <div class="menu-actions">
                    <button class="ghost" type="button" @click="recordMenuSale(item, 1)" :disabled="item.sold >= item.target">
                      售出 1 {{ menuUnitLabel(item) }}
                    </button>
                    <div class="menu-qty">
                      <button class="ghost" type="button" @click="adjustMenuTarget(item, -5)">-5</button>
                      <span>今日份数</span>
                      <button class="ghost" type="button" @click="adjustMenuTarget(item, 5)">+5</button>
                    </div>
                    <button class="ghost" type="button" @click="toggleMenuAvailability(item)">
                      {{ item.status === 'ACTIVE' ? '暂停售卖' : '恢复售卖' }}
                    </button>
                  </div>
                </article>
              </div>
              <div class="store-gate-empty" v-else>
                <p>还没有上架的商品，先从上方选择饮品并设置份数。</p>
              </div>
              <p class="feedback" v-if="menuAlert">{{ menuAlert }}</p>
            </section>

            <section class="merchant-orders">
              <header class="section-header">
                <div>
                  <h2>订单中心</h2>
                  <p class="section-desc">查看实时队列，按阶段完成出杯。</p>
                </div>
              </header>
              <div class="merchant-pipeline">
                <article v-for="stage in merchantOrderStages" :key="stage.key">
                  <p class="card-label">{{ stage.label }}</p>
                  <strong>{{ stage.value }}</strong>
                  <small>{{ stage.desc }}</small>
                </article>
              </div>
              <div class="order-board order-board-limited" v-if="merchantBoard.orders.length">
                <article v-for="order in merchantBoard.orders" :key="order.id" class="order-card">
                  <header>
                    <h3>{{ order.drinkName }} × {{ order.quantity }}</h3>
                    <span class="status" :class="order.status.toLowerCase()">{{ statusLabel(order.status) }}</span>
                  </header>
                  <ul>
                    <li>顾客：{{ order.customerName }}</li>
                    <li>联系电话：{{ order.contactPhone }}</li>
                    <li>取餐时间：{{ order.pickupTime || '尽快' }}</li>
                    <li v-if="order.customSummary">出品备注：{{ order.customSummary }}</li>
                    <li>下单时间：{{ formatTime(order.createdAt) }}</li>
                  </ul>
                  <footer>
                    <button
                      v-for="transition in nextStatuses(order.status)"
                      :key="transition.code"
                      class="primary"
                      @click="changeOrderStatus(order.id, transition.code, order)"
                    >
                      {{ transition.label }}
                    </button>
                  </footer>
                </article>
              </div>
              <p class="order-scroll-hint" v-if="merchantBoard.orders.length > 6">向下滑动查看更多订单</p>
              <div class="empty-state" v-else>
                <h2>暂时没有新订单</h2>
                <p>喝杯咖啡休息一下，新的灵感随时会来。</p>
              </div>
            </section>
          </div>
        </template>
        <template v-else>
          <OrderForm
            :drinks="productLibrary"
            :merchants="merchants"
            :preferred-merchant-id="selectedMerchantId"
            :submit-order="submitCustomerOrder"
          />
        </template>
      </section>

      <section v-else-if="activeTab === 'explore'" class="panel explore-panel">
        <template v-if="isAdmin">
          <div class="admin-explore-switch">
            <button
              type="button"
              :class="{ active: adminExploreTab === 'accounts' }"
              @click="adminExploreTab = 'accounts'"
            >
              账号管理
            </button>
            <button
              type="button"
              :class="{ active: adminExploreTab === 'merchants' }"
              @click="adminExploreTab = 'merchants'"
            >
              商家管理
            </button>
          </div>
          <AccountManagement v-if="adminExploreTab === 'accounts'" />
          <MerchantManagement v-else :on-refresh="refreshMerchantsOnly" />
        </template>
        <template v-else>
          <template v-if="isMerchant">
            <article class="product-library-panel">
              <header class="section-header">
                <div>
                  <h2>商品库 · 品类管理</h2>
                <p class="section-desc">统一维护顾客端与门店共享的商品档案。</p>
              </div>
              <small>共 {{ productLibrary.length }} 款商品</small>
            </header>
            <form class="product-form" @submit.prevent="saveProduct">
              <div class="form-grid">
                <label>
                  <span>商品分类</span>
                  <select v-model="productForm.category">
                    <option v-for="category in productCategories" :key="category.value" :value="category.value">
                      {{ category.label }}
                    </option>
                  </select>
                </label>
                <label>
                  <span>商品名称</span>
                  <input v-model="productForm.name" type="text" placeholder="例如：桂花拿铁" />
                  <small class="error" v-if="productErrors.name">{{ productErrors.name }}</small>
                </label>
                <label>
                  <span>销售价格</span>
                  <input v-model.number="productForm.price" type="number" min="1" step="0.5" placeholder="28" />
                  <small class="error" v-if="productErrors.price">{{ productErrors.price }}</small>
                </label>
                <label>
                  <span>展示图片</span>
                  <input v-model="productForm.imageUrl" type="url" placeholder="https://example.com/image.jpg" />
                  <input type="file" accept="image/*" @change="handleProductImageUpload" />
                </label>
                <label class="full-width">
                  <span>一句话描述</span>
                  <textarea v-model="productForm.description" rows="2" placeholder="口感或灵感来源"></textarea>
                </label>
                <label>
                  <span>标签（可选）</span>
                  <input v-model="productForm.tag" type="text" placeholder="季节限定 / 热卖" />
                </label>
                <label>
                  <span>在售状态</span>
                  <div class="toggle-row">
                    <input type="checkbox" id="product-available" v-model="productForm.available" />
                    <span>{{ productForm.available ? '在售 · 客户可见' : '已下架 · 顾客端隐藏' }}</span>
                  </div>
                </label>
                <section class="option-section" v-if="showSugarOptions">
                  <header>
                    <h4>饮品糖度</h4>
                    <small>顾客下单前需选择糖度</small>
                  </header>
                  <ul class="option-list">
                    <li v-for="option in productForm.optionSettings.sugar.options" :key="option.value">
                      <div class="option-info">
                        <strong>{{ option.label }}</strong>
                        <small>{{ sugarOptionHints[option.value] }}</small>
                      </div>
                      <div class="option-controls">
                        <label>
                          <input
                            type="checkbox"
                            v-model="option.visible"
                            @change="handleOptionVisibilityChange('sugar')"
                            :disabled="
                              option.visible && countVisibleOptions(productForm.optionSettings.sugar) <= 1
                            "
                          />
                          <span>展示</span>
                        </label>
                        <label>
                          <input
                            type="radio"
                            name="sugar-default"
                            :value="option.value"
                            v-model="productForm.optionSettings.sugar.defaultValue"
                            :disabled="!option.visible"
                          />
                          <span>默认</span>
                        </label>
                      </div>
                    </li>
                  </ul>
                </section>
                <section class="option-section" v-if="showPourOptions">
                  <header>
                    <h4>手冲演示</h4>
                    <small>可选择是否进行现场冲煮演示</small>
                  </header>
                  <ul class="option-list">
                    <li v-for="option in productForm.optionSettings.pourDemo.options" :key="option.value">
                      <div class="option-info">
                        <strong>{{ option.label }}</strong>
                        <small>{{ pourOptionHints[option.value] }}</small>
                      </div>
                      <div class="option-controls">
                        <label>
                          <input
                            type="checkbox"
                            v-model="option.visible"
                            @change="handleOptionVisibilityChange('pourDemo')"
                            :disabled="
                              option.visible && countVisibleOptions(productForm.optionSettings.pourDemo) <= 1
                            "
                          />
                          <span>展示</span>
                        </label>
                        <label>
                          <input
                            type="radio"
                            name="pour-default"
                            :value="option.value"
                            v-model="productForm.optionSettings.pourDemo.defaultValue"
                            :disabled="!option.visible"
                          />
                          <span>默认</span>
                        </label>
                      </div>
                    </li>
                  </ul>
                </section>
                <section class="option-section" v-if="showTablewareOptions">
                  <header>
                    <h4>餐具数量</h4>
                    <small>甜品下单默认附带餐具</small>
                  </header>
                  <ul class="option-list">
                    <li v-for="option in productForm.optionSettings.tableware.options" :key="option.value">
                      <div class="option-info">
                        <strong>{{ option.label }}</strong>
                        <small>{{ tablewareOptionHints[option.value] }}</small>
                      </div>
                      <div class="option-controls">
                        <label>
                          <input
                            type="checkbox"
                            v-model="option.visible"
                            @change="handleOptionVisibilityChange('tableware')"
                            :disabled="
                              option.visible && countVisibleOptions(productForm.optionSettings.tableware) <= 1
                            "
                          />
                          <span>展示</span>
                        </label>
                        <label>
                          <input
                            type="radio"
                            name="tableware-default"
                            :value="option.value"
                            v-model="productForm.optionSettings.tableware.defaultValue"
                            :disabled="!option.visible"
                          />
                          <span>默认</span>
                        </label>
                      </div>
                    </li>
                  </ul>
                </section>
              </div>
              <div class="form-actions">
                <button class="primary" type="submit" :disabled="productSaving">
                  {{ productSaving ? '保存中...' : productForm.id ? '更新商品' : '新增商品' }}
                </button>
                <button class="ghost" type="button" v-if="productForm.id" @click="resetProductForm">取消编辑</button>
              </div>
            </form>
            <p class="feedback" v-if="merchantHomeNotice">{{ merchantHomeNotice }}</p>
            <div class="library-summary">
              <article v-for="category in productCategories" :key="category.value" class="summary-card">
                <div class="summary-head">
                  <div class="summary-icon">{{ category.icon }}</div>
                  <div>
                    <p class="summary-label">{{ category.label }}</p>
                    <strong>{{ productLibraryByCategory[category.value]?.length || 0 }} 款</strong>
                  </div>
                </div>
                <p>{{ category.desc }}</p>
              </article>
              <p class="library-tip">详细编辑和删除请下滑至“灵感单专场”进行管理。</p>
            </div>
            <CategoryShowcase
              :drinks="productLibrary"
              initial-category="DESSERT"
              :cart-items="[]"
              :cart-summary="null"
              :cart-total="0"
              :add-to-cart="null"
              :increment-item="null"
              :decrement-item="null"
              :clear-cart="null"
              :is-merchant="true"
              :on-edit-product="editProduct"
              :on-delete-product="deleteProduct"
              @checkout="enterCheckout"
            />
            </article>
          </template>
          <template v-else>
            <CategoryShowcase
              v-if="selectedMerchant"
              :drinks="productLibrary"
              initial-category="DESSERT"
              :cart-items="sharedCartItems"
              :cart-summary="sharedCartSummary"
              :cart-total="sharedCartTotal"
              :add-to-cart="addCartItem"
              :increment-item="addCartItem"
              :decrement-item="decrementCartItem"
              :clear-cart="clearSharedCart"
              :is-merchant="false"
              :on-edit-product="null"
              :on-delete-product="null"
              @checkout="enterCheckout"
            />
            <div v-else class="store-gate-empty explore-empty">
              <p>选择门店后即可浏览灵感单和场景推荐。</p>
              <button class="ghost" type="button" @click="openStorePicker">选择门店</button>
            </div>
          </template>
        </template>
      </section>

      <section v-else-if="activeTab === 'storePicker'" class="panel store-picker-page">
        <header class="store-page-header">
          <button class="ghost back-link" type="button" @click="closeStorePicker">‹ 返回</button>
          <div>
            <p class="store-title">选择取杯门店</p>
            <small class="store-note">{{ locationStatusText }}</small>
          </div>
          <button
            class="ghost"
            type="button"
            :disabled="locationStatus === 'pending' || !geolocationSupported"
            @click="requestLocation"
          >
            {{ locationButtonLabel }}
          </button>
        </header>
        <p class="store-intro">下单前先锁定离你最近的门店，便于安排取杯与通知。</p>
        <ul class="store-list">
          <li v-for="store in sortedMerchants" :key="store.id">
            <button
              type="button"
              :class="{ active: storePicker.selectedId === store.id }"
              @click="storePicker.selectedId = store.id"
            >
              <div>
                <strong>{{ store.name }}</strong>
                <span>{{ store.location || '地址待完善' }}</span>
              </div>
              <div class="distance" v-if="store.distance !== null">{{ store.distance.toFixed(1) }} km</div>
              <div class="distance" v-else>--</div>
            </button>
          </li>
          <li v-if="!sortedMerchants.length" class="store-empty">暂无可选门店</li>
        </ul>
        <div class="store-actions">
          <button class="ghost" type="button" @click="closeStorePicker">取消</button>
          <button class="primary" type="button" :disabled="!storePicker.selectedId" @click="confirmStoreSelection">
            确认门店
          </button>
        </div>
        <small v-if="locationStatus === 'denied'" class="store-denied">定位被拒，可在浏览器设置中允许权限</small>
      </section>

      <section v-else-if="activeTab === 'checkout'" class="panel checkout-panel">
        <header class="checkout-store">
          <div>
            <p class="section-label">取杯门店</p>
            <h2>{{ selectedMerchant?.name || '请选择门店' }}</h2>
            <small>{{ selectedMerchant?.location || '请选择门店以继续下单' }}</small>
          </div>
          <button class="ghost" type="button" @click="openStorePicker">切换门店</button>
        </header>

        <div class="checkout-contact" v-if="currentUser">
          <div>
            <p>取餐联系人</p>
            <strong>{{ orderContactName || '请完善称呼' }}</strong>
          </div>
          <div>
            <p>联系电话</p>
            <strong>{{ orderContactPhone || '请完善手机号' }}</strong>
          </div>
          <button class="ghost" type="button" @click="handleProfileAction('info')">完善资料</button>
        </div>
        <div class="checkout-contact warning" v-else>
          <div>
            <p>尚未登录</p>
            <small>登录后才能提交订单</small>
          </div>
          <button class="primary" type="button" @click="activeTab = 'profileLogin'">立即登录</button>
        </div>

        <section class="checkout-pickup">
          <header>
            <p>取餐方式</p>
            <small>{{ pickupMethodText }}</small>
          </header>
          <div class="pickup-options">
            <button
              v-for="option in pickupOptions"
              :key="option.value"
              type="button"
              :class="{ active: pickupMethod === option.value }"
              @click="pickupMethod = option.value"
            >
              <strong>{{ option.label }}</strong>
              <span>{{ option.desc }}</span>
            </button>
          </div>
        </section>

        <section class="checkout-products">
          <header>
            <div>
              <p>已选商品</p>
              <small>{{ sharedCartSummary }}</small>
            </div>
            <button class="ghost" type="button" @click="activeTab = 'home'">继续加购</button>
          </header>
          <ul v-if="sharedCartItems.length" class="checkout-list">
            <li v-for="item in sharedCartItems" :key="item.id">
              <div class="thumb" :style="checkoutThumbStyle(item)">
                <span v-if="item.tag" class="mini-tag">{{ item.tag }}</span>
              </div>
              <div class="item-info">
                <h3>{{ item.name }}</h3>
                <p>{{ item.customSummary || '标准出品' }}</p>
                <span>¥ {{ Number(item.price || 0).toFixed(2) }}</span>
              </div>
              <div class="item-qty">× {{ item.quantity }}</div>
            </li>
          </ul>
          <p v-else class="cart-empty">购物车为空，去首页挑选喜欢的商品吧</p>
        </section>

        <div class="checkout-summary">
          <span>共 {{ sharedCartCount }} 件</span>
          <strong>¥ {{ sharedCartTotal.toFixed(2) }}</strong>
        </div>

        <div class="checkout-remark">
          <div>
            <p>订单备注</p>
            <small>{{ orderRemark || '口味、包装等特殊要求' }}</small>
          </div>
          <button class="ghost" type="button" @click="remarkEditorOpen = !remarkEditorOpen">
            {{ remarkEditorOpen ? '完成' : '编辑' }}
          </button>
        </div>
        <textarea
          v-if="remarkEditorOpen"
          class="remark-editor"
          v-model="orderRemark"
          placeholder="示例：少糖、另外附赠纸袋"
        ></textarea>

        <p class="feedback" v-if="checkoutFeedback">{{ checkoutFeedback }}</p>

        <button
          class="primary checkout-submit"
          type="button"
          :disabled="checkoutDisabled"
          @click="handleCheckoutSubmit"
        >
          {{ checkoutSubmitting ? '下单中…' : `确认下单 · ¥ ${sharedCartTotal.toFixed(2)}` }}
        </button>
      </section>

      <section v-else-if="activeTab === 'profile'" class="panel profile">
        <div class="profile-hero banner-card">
          <img class="banner-bg" :src="profileBanner" alt="个人背景" />
          <div class="banner-overlay"></div>
          <button class="ghost icon-only banner-action" type="button" @click="handleProfileAction('info')">⚙️</button>
          <div class="banner-content">
            <p class="banner-greeting">{{ heroGreeting }}</p>
            <small class="banner-role">{{ currentUser ? heroSubtitle : '未登录 · 游客模式' }}</small>
          </div>
          <div class="hero-avatar">
            <img v-if="profileAvatar" :src="profileAvatar" alt="当前头像" />
            <span v-else>{{ currentUser ? (currentUser.displayName || currentUser.username).slice(0, 1) : '访' }}</span>
          </div>
        </div>

        <div class="profile-highlights">
          <article v-for="card in profileHighlights" :key="card.label">
            <p class="card-label">{{ card.label }}</p>
            <strong>{{ card.value }}</strong>
            <span>{{ card.desc }}</span>
          </article>
        </div>

        <template v-if="isMerchant">
          <section class="merchant-profile-overview">
            <div class="status-overview">
              <p class="card-label">营业状态</p>
              <strong>{{ merchantStatusLabel }}</strong>
              <small>{{ merchantStatusNote || '暂无营业提示' }}</small>
            </div>
            <ul class="status-metrics">
              <li>
                <p class="card-label">轮播图</p>
                <strong>{{ merchantCarousel.length }}</strong>
                <small>顾客端首页</small>
              </li>
              <li>
                <p class="card-label">今日推荐</p>
                <strong>{{ recommendationSlots.filter((slot) => merchantRecommendations[slot.key]).length }}</strong>
                <small>已配置栏目</small>
              </li>
              <li>
                <p class="card-label">上架商品</p>
                <strong>{{ dailyMenu.length }}</strong>
                <small>今日菜单</small>
              </li>
            </ul>
          </section>
          <div class="profile-actions merchant-profile-actions">
            <button
              v-for="item in profileActions"
              :key="item.key"
              type="button"
              @click="handleProfileAction(item.key)"
            >
              <div class="action-icon">{{ item.icon }}</div>
              <div class="action-info">
                <p>{{ item.label }}</p>
                <small>{{ item.desc }}</small>
              </div>
              <span class="action-arrow">›</span>
            </button>
          </div>
          <div class="current-user detail-card">
            <p>
              当前登录：<strong>{{ currentUser?.displayName }}</strong>（{{ currentUser?.username }}） · 角色：{{ roleLabel(currentUser?.role) }}
            </p>
            <p v-if="currentUser?.merchantName">所属门店：{{ currentUser.merchantName }}</p>
            <button class="ghost" type="button" @click="logout">退出登录</button>
          </div>
        </template>
        <template v-else>
          <div class="profile-actions">
            <button
              v-for="item in profileActions"
              :key="item.key"
              type="button"
              @click="handleProfileAction(item.key)"
            >
              <div class="action-icon">{{ item.icon }}</div>
              <div class="action-info">
                <p>{{ item.label }}</p>
                <small>{{ item.desc }}</small>
              </div>
              <span class="action-arrow">›</span>
            </button>
          </div>

          <div v-if="currentUser" class="current-user detail-card">
            <p>
              当前登录：<strong>{{ currentUser.displayName }}</strong>（{{ currentUser.username }}） · 角色：{{ roleLabel(currentUser.role) }}
            </p>
            <p v-if="currentUser.merchantName">所属门店：{{ currentUser.merchantName }}</p>
            <button class="ghost" type="button" @click="logout">退出登录</button>
          </div>
          <div v-else class="auth-card profile-auth compact">
            <p class="cta-hint">登录后可同步订单、查看积分</p>
            <button class="primary gate-cta" type="button" @click="activeTab = 'profileLogin'">立即登录</button>
          </div>
        </template>
      </section>

      <section v-else-if="activeTab === 'profileLogin'" class="panel profile auth-full">
        <button class="ghost back-link" type="button" @click="activeTab = 'profile'">‹ 返回我的</button>
        <div class="auth-card profile-auth">
          <div class="tabs">
            <button :class="{ active: authMode === 'login' }" @click="setAuthMode('login')">登录</button>
            <button :class="{ active: authMode === 'register' }" @click="setAuthMode('register')">注册</button>
          </div>
          <form class="form" @submit.prevent="submitAuth">
            <div class="role-switcher" v-if="authMode === 'login'">
              <button
                v-for="role in roles"
                :key="role.value"
                type="button"
                :class="{ active: loginRole === role.value }"
                @click="setLoginRole(role.value)"
              >
                {{ role.label }}登录
              </button>
            </div>
            <div class="form-row">
              <label>用户名</label>
              <input v-model="authForm.username" type="text" placeholder="请输入用户名" autocomplete="username" />
              <span class="error" v-if="authErrors.username">{{ authErrors.username }}</span>
            </div>
            <div class="form-row" v-if="authMode === 'register'">
              <label>昵称</label>
              <input v-model="authForm.displayName" type="text" placeholder="用于展示的昵称" autocomplete="nickname" />
              <span class="error" v-if="authErrors.displayName">{{ authErrors.displayName }}</span>
            </div>
            <div class="form-row">
              <label>密码</label>
              <input v-model="authForm.password" type="password" placeholder="请输入密码" autocomplete="current-password" />
              <span class="error" v-if="authErrors.password">{{ authErrors.password }}</span>
            </div>
            <div class="form-row" v-if="authMode === 'register'">
              <label>注册角色</label>
              <select v-model="registerRole">
                <option v-for="role in roles" :key="role.value" :value="role.value">{{ role.label }}</option>
              </select>
            </div>
            <div class="form-row" v-if="authMode === 'register' && registerRole === 'MERCHANT'">
              <label>关联门店</label>
              <select v-model="authForm.merchantId">
                <option disabled value="">请选择门店</option>
                <option v-for="merchant in merchants" :key="merchant.id" :value="merchant.id">
                  {{ merchant.name }} · {{ merchant.location }}
                </option>
              </select>
              <span class="error" v-if="authErrors.merchantId">{{ authErrors.merchantId }}</span>
            </div>
            <div class="actions">
              <button class="primary gate-cta" type="submit" :disabled="authPrimaryDisabled">
                {{ authPrimaryLabel }}
              </button>
              <small class="form-hint" v-if="authMode === 'register' && registerCooldown > 0">
                注册过于频繁，请 {{ registerCooldown }} 秒后再试
              </small>
              <button class="ghost" type="button" v-if="authMode === 'register'" @click="setAuthMode('login')">已有帐号？去登录</button>
            </div>
          </form>
          <p class="feedback" v-if="authFeedback">{{ authFeedback }}</p>
        </div>
      </section>

      <section v-else-if="activeTab === 'profileSettings'" class="panel profile settings-panel">
        <header class="settings-header">
          <button class="ghost back-link" type="button" @click="activeTab = 'profile'">‹ 返回</button>
          <h2>个人资料</h2>
          <button class="ghost icon-only" type="button" @click="showProfileHints">···</button>
        </header>

        <div v-if="profileLoading" class="empty-state">
          <h2>加载资料中...</h2>
          <p>请稍候，正在同步账户信息。</p>
        </div>

        <div v-else-if="currentUser" class="settings-body">
          <div class="settings-card">
            <div class="avatar-preview">
              <div class="avatar-shell large">
                <img v-if="avatarDisplay" :src="avatarDisplay" alt="当前头像" />
                <span v-else>{{ profileInitial }}</span>
                <button class="avatar-edit" type="button" :disabled="avatarUploading" @click="triggerAvatarPicker">
                  {{ avatarUploading ? '上传中...' : '更换' }}
                </button>
                <input
                  ref="avatarInputRef"
                  type="file"
                  accept="image/*"
                  capture="environment"
                  class="visually-hidden"
                  :disabled="avatarUploading"
                  @change="handleAvatarFile"
                />
              </div>
              <small class="upload-hint" v-if="avatarUploading">正在上传，请稍候...</small>
              <p class="membership-date">{{ membershipCopy }}</p>
              <small class="membership-code" v-if="!isAdmin">会员 NO.{{ membershipCode }}</small>
            </div>
          </div>

          <form class="profile-form" @submit.prevent="submitProfile">
            <div class="form-row required">
              <label>昵称</label>
              <input v-model.trim="profileForm.displayName" type="text" placeholder="请输入昵称" />
              <span class="error" v-if="profileErrors.displayName">{{ profileErrors.displayName }}</span>
            </div>
            <div class="form-row">
              <label>姓氏</label>
              <input v-model.trim="profileForm.familyName" type="text" placeholder="请输入姓氏" />
            </div>
            <div class="form-row">
              <label>名字</label>
              <input v-model.trim="profileForm.givenName" type="text" placeholder="请输入名字" />
            </div>
            <div class="form-row">
              <label>性别</label>
              <select v-model="profileForm.gender">
                <option value="">请选择</option>
                <option v-for="option in genderOptions" :key="option" :value="option">{{ option }}</option>
              </select>
            </div>
            <div class="form-row">
              <label>手机</label>
              <input v-model.trim="profileForm.phone" type="tel" placeholder="点击填写手机号" />
            </div>
            <div class="form-row">
              <label>生日</label>
              <input v-model="profileForm.birthday" type="date" placeholder="请选择你的生日" />
            </div>
            <div class="actions sticky-actions">
              <button class="primary" type="submit" :disabled="profileSaving">
                {{ profileSaving ? '保存中...' : '保存' }}
              </button>
            </div>
            <p class="feedback" v-if="profileFeedback">{{ profileFeedback }}</p>
          </form>
        </div>

        <div v-else class="empty-state">
          <h2>请先登录</h2>
          <p>登录后即可编辑个人资料并同步到数据库。</p>
          <button class="primary" type="button" @click="activeTab = 'profileLogin'">去登录</button>
        </div>
      </section>
    </main>

    <nav class="tabbar" :class="{ compact: !showWorkbench }">
      <button :class="{ active: activeTab === 'home' || activeTab === 'checkout' }" @click="activeTab = 'home'">
        <span class="icon">🏠</span>
        <span>首页</span>
      </button>
      <button v-if="showWorkbench" :class="{ active: activeTab === 'order' }" @click="activeTab = 'order'">
        <span class="icon">🧾</span>
        <span>工作台</span>
      </button>
      <button :class="{ active: activeTab === 'explore' }" @click="activeTab = 'explore'">
        <span class="icon">✨</span>
        <span>{{ isAdmin ? '账号' : '灵感' }}</span>
      </button>
      <button
        :class="{
          active:
            activeTab === 'profile' ||
            activeTab === 'profileLogin' ||
            activeTab === 'profileSettings'
        }"
        @click="activeTab = 'profile'"
      >
        <span class="icon">👤</span>
        <span>我的</span>
      </button>
    </nav>
  </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, reactive, ref, watch } from 'vue'
const brandLogo = new URL('./assets/logo.png', import.meta.url).href
const profileBg = brandLogo
import OrderForm from './components/OrderForm.vue'
import HomeShowcase from './components/HomeShowcase.vue'
import CategoryShowcase from './components/CategoryShowcase.vue'
import AccountManagement from './components/AccountManagement.vue'
import MerchantManagement from './components/MerchantManagement.vue'
import {
  login,
  register,
  fetchAdminOverview,
  fetchCatalogDrinks,
  fetchMerchants,
  createOrder,
  fetchOrderOverview,
  fetchMerchantBanners,
  fetchMerchantOrders,
  updateMerchantOrderStatus,
  fetchUserProfile,
  updateUserProfile,
  uploadAvatar,
  uploadAsset,
  createMerchantProduct,
  updateMerchantProduct,
  deleteMerchantProduct,
  listMerchantBanners,
  createMerchantBanner,
  deleteMerchantBanner,
  createAlipayPayment,
  fetchMerchantRequests,
  approveMerchantRequest,
  rejectMerchantRequest,
  setAuthToken
} from './services/api'
import { buildAssetUrl, sanitizeAssetPath } from './services/assets'

const roles = [
  { label: '管理员', value: 'ADMIN' },
  { label: '商家', value: 'MERCHANT' },
  { label: '顾客', value: 'CUSTOMER' }
]

const productCategories = [
  { value: 'CLASSIC', label: '经典咖啡', icon: '☕️', desc: '顺口经典款，日常稳妥选择。' },
  { value: 'SIGNATURE', label: '灵感特调', icon: '✨', desc: '限时灵感，甜感与香气更有记忆点。' },
  { value: 'POUR', label: '手冲风味', icon: '🫖', desc: '产区风味旅程，慢慢品出层次。' },
  { value: 'DESSERT', label: '甜品点心', icon: '🍰', desc: '巴斯克与烘焙小点，搭配咖啡更完整。' }
]

const membershipTiers = [
  { code: 'EXPERIENCE', label: '体验会员', threshold: 0 },
  { code: 'PREFERRED', label: '优享会员', threshold: 500 },
  { code: 'INSPIRE', label: '灵感挚友', threshold: 1500 },
  { code: 'CURATOR', label: '主理人好友', threshold: 3000 }
]

const resolveMembershipTier = (code) => {
  const normalized = String(code || '').toUpperCase()
  return membershipTiers.find((tier) => tier.code === normalized) || membershipTiers[0]
}

const normalizeCategory = (value) => {
  const upper = String(value || '').toUpperCase()
  if (productCategories.some((cat) => cat.value === upper)) {
    return upper
  }
  return productCategories[0].value
}

const sugarOptionPresets = [
  { value: 'seven', label: '店主推荐' },
  { value: 'five', label: '半糖' },
  { value: 'zero', label: '无糖' }
]
const sugarOptionHints = {
  seven: '遵循店主配比，风味最平衡',
  five: '减少糖量，保留配方原味',
  zero: '完全不额外加糖，清爽顺口'
}
const tablewareOptionPresets = [
  { value: 'one', label: '1份' },
  { value: 'two', label: '2份' },
  { value: 'none', label: '不需要' }
]
const tablewareOptionHints = {
  one: '适合单人享用',
  two: '两人分享更方便',
  none: '顾客自带或无需餐具'
}
const pourOptionPresets = [
  { value: 'show', label: '需要现场演示' },
  { value: 'skip', label: '不需要演示' }
]
const pourOptionHints = {
  show: '店主将当面冲煮并讲解器具细节',
  skip: '直接取杯，节省时间'
}

const buildOptionGroup = (presets, savedGroup, enabled, fallbackValue) => {
  const group = {
    enabled,
    defaultValue: savedGroup?.defaultValue || fallbackValue,
    options: presets.map((preset) => {
      const matched = savedGroup?.options?.find((opt) => opt.value === preset.value)
      return {
        value: preset.value,
        label: matched?.label || preset.label,
        visible: matched?.visible !== false
      }
    })
  }
  const visibleOptions = group.options.filter((option) => option.visible)
  if (!visibleOptions.length) {
    group.options.forEach((option) => (option.visible = true))
    group.defaultValue = group.options[0]?.value || fallbackValue
  } else if (!visibleOptions.some((option) => option.value === group.defaultValue)) {
    group.defaultValue = visibleOptions[0].value
  }
  return group
}

const createOptionSettingsForCategory = (category, savedSettings = null) => {
  const normalized = normalizeCategory(category)
  const sugarEnabled = ['CLASSIC', 'SIGNATURE'].includes(normalized)
  return {
    sugar: buildOptionGroup(sugarOptionPresets, savedSettings?.sugar, sugarEnabled, 'seven'),
    tableware: buildOptionGroup(tablewareOptionPresets, savedSettings?.tableware, normalized === 'DESSERT', 'one'),
    pourDemo: buildOptionGroup(pourOptionPresets, savedSettings?.pourDemo, normalized === 'POUR', 'skip')
  }
}

const countVisibleOptions = (group) => (group?.options || []).filter((option) => option.visible).length

const adminPanels = [
  { key: 'overview', label: '数据概览', desc: '掌控业务关键指标', icon: '数据' },
  { key: 'merchants', label: '商家管理', desc: '门店与账号权限', icon: '商家' }
]

const merchantRequests = ref([])
const merchantRequestsLoading = ref(false)
const merchantRequestsError = ref('')
const merchantRequestProcessing = ref('')

const normalizeMerchantRequest = (item = {}) => {
  const status = String(item.status || 'PENDING').toUpperCase()
  const submittedAt = formatDateLabel(item.createdAt)
  const processedAt = item.processedAt ? formatDateLabel(item.processedAt) : ''
  const fallbackId = `REQ-${Date.now()}-${Math.round(Math.random() * 1000)}`
  return {
    id: item.id || item.requestId || fallbackId,
    merchantName: item.merchantName || item.name || '未命名门店',
    applicant: item.applicantName || item.contactName || '申请人未填写',
    phone: item.phone || item.contactPhone || '—',
    location: item.location || item.address || '地址待补充',
    note: item.note || item.remark || '',
    status,
    submittedAt,
    processedAt,
    isToday: item.createdAt ? isTodayDate(item.createdAt) : false
  }
}

const pendingMerchantRequests = computed(() =>
  merchantRequests.value.filter((request) => request.status === 'PENDING')
)

const processedMerchantRequests = computed(() =>
  merchantRequests.value
    .filter((request) => request.status !== 'PENDING')
    .slice(0, 5)
)

const merchantRequestPreview = computed(() => pendingMerchantRequests.value.slice(0, 3))

const merchantApprovalStats = computed(() => {
  const total = merchantRequests.value.length
  const pending = pendingMerchantRequests.value.length
  const today = pendingMerchantRequests.value.filter((request) => request.isToday).length
  return {
    total,
    pending,
    today
  }
})

const activeTab = ref('home')
const adminExploreTab = ref('accounts')
const adminActivePanel = ref(adminPanels[0].key)

const openAdminManager = (target = 'merchants') => {
  adminExploreTab.value = target === 'merchants' ? 'merchants' : 'accounts'
  activeTab.value = 'explore'
}
const productLibrary = ref([])
const productForm = reactive({
  id: null,
  category: productCategories[0].value,
  name: '',
  price: '',
  description: '',
  imageUrl: '',
  tag: '',
  available: true,
  optionSettings: createOptionSettingsForCategory(productCategories[0].value)
})
const productErrors = reactive({})
const currentProductCategory = computed(() => normalizeCategory(productForm.category))
const showSugarOptions = computed(() => ['CLASSIC', 'SIGNATURE'].includes(currentProductCategory.value))
const showPourOptions = computed(() => currentProductCategory.value === 'POUR')
const showTablewareOptions = computed(() => currentProductCategory.value === 'DESSERT')
const assignOptionSettings = (category, savedSettings = null) => {
  const resolved = createOptionSettingsForCategory(category, savedSettings)
  productForm.optionSettings.sugar = resolved.sugar
  productForm.optionSettings.tableware = resolved.tableware
  productForm.optionSettings.pourDemo = resolved.pourDemo
}
const ensureGroupDefault = (group) => {
  if (!group) return
  const visible = (group.options || []).filter((option) => option.visible)
  if (!visible.length) {
    group.options.forEach((option) => (option.visible = true))
    group.defaultValue = group.options[0]?.value || ''
    return
  }
  if (!visible.some((option) => option.value === group.defaultValue)) {
    group.defaultValue = visible[0].value
  }
}
const handleOptionVisibilityChange = (groupKey) => {
  const group = productForm.optionSettings[groupKey]
  ensureGroupDefault(group)
}
watch(
  () => productForm.category,
  (category) => {
    assignOptionSettings(category, productForm.optionSettings)
  }
)
const merchants = ref([])
const merchantBoard = reactive({
  merchantName: '',
  received: 0,
  preparing: 0,
  ready: 0,
  completed: 0,
  orders: []
})
const sharedCart = reactive({})
const sharedCartItems = computed(() => Object.values(sharedCart))
const sharedCartCount = computed(() => sharedCartItems.value.reduce((sum, item) => sum + (item.quantity || 0), 0))
const sharedCartTotal = computed(() =>
  sharedCartItems.value.reduce((sum, item) => sum + Number(item.price || 0) * (item.quantity || 0), 0)
)
const numberFormatter = new Intl.NumberFormat('zh-CN')
const formatCount = (value) => numberFormatter.format(Math.max(0, Number(value) || 0))
const padNumber = (value) => String(value).padStart(2, '0')
const isTodayDate = (value) => {
  if (!value) return false
  const target = new Date(value)
  if (Number.isNaN(target.getTime())) return false
  const now = new Date()
  return (
    target.getFullYear() === now.getFullYear() &&
    target.getMonth() === now.getMonth() &&
    target.getDate() === now.getDate()
  )
}
const formatDateLabel = (value) => {
  if (!value) return '--'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return value
  const month = padNumber(date.getMonth() + 1)
  const day = padNumber(date.getDate())
  const hour = padNumber(date.getHours())
  const minute = padNumber(date.getMinutes())
  return `${month}-${day} ${hour}:${minute}`
}
const sharedCartSummary = computed(() =>
  sharedCartCount.value ? `共 ${sharedCartCount.value} 件 · ¥ ${sharedCartTotal.value.toFixed(2)}` : '购物车为空'
)

const normalizeCartEntry = (item = {}) => {
  const signature = item.cartSignature || item.id || item.drinkId
  return {
    id: signature,
    cartSignature: signature,
    drinkId: item.drinkId ?? item.id ?? signature,
    name: item.name,
    price: Number(item.price) || 0,
    imageUrl: item.imageUrl || item.image,
    merchantName: item.merchantName || '',
    tag: item.tag,
    customSummary: item.customSummary || '',
    customizations: item.customizations || null,
    quantity: Number(item.quantity) || 0
  }
}

const addCartItem = (item) => {
  if (!item) return
  const payload = normalizeCartEntry(item)
  if (!payload.id) return
  const key = String(payload.id)
  if (!sharedCart[key]) {
    sharedCart[key] = { ...payload, quantity: 0 }
  }
  if (payload.customSummary) {
    sharedCart[key].customSummary = payload.customSummary
  }
  if (payload.customizations) {
    sharedCart[key].customizations = payload.customizations
  }
  sharedCart[key].quantity += payload.quantity || 1
}

const decrementCartItem = (item) => {
  if (!item?.id) return
  const key = String(item.id)
  if (!sharedCart[key]) return
  sharedCart[key].quantity -= 1
  if (sharedCart[key].quantity <= 0) {
    delete sharedCart[key]
  }
}

const clearSharedCart = () => {
  Object.keys(sharedCart).forEach((key) => delete sharedCart[key])
}
const adminOverview = ref(null)
const orderOverview = ref(null)
const adminCommandFeedback = ref('')

const authMode = ref('login')
const loginRole = ref('CUSTOMER')
const registerRole = ref('CUSTOMER')
const authForm = reactive({
  username: '',
  displayName: '',
  password: '',
  merchantId: ''
})
const authErrors = reactive({})
const authFeedback = ref('')
const currentUser = ref(null)
const authSessionToken = ref('')
const authSubmitting = ref(false)
const registerCooldown = ref(0)
const REGISTER_COOLDOWN_SECONDS = 5
let registerCooldownTimer = null

const authPrimaryLabel = computed(() => {
  if (authMode.value === 'register') {
    if (authSubmitting.value) return '注册中…'
    if (registerCooldown.value > 0) return `稍后再试（${registerCooldown.value}s）`
    return '立即注册'
  }
  return authSubmitting.value ? '登录中…' : '立即登录'
})

const authPrimaryDisabled = computed(
  () => authSubmitting.value || (authMode.value === 'register' && registerCooldown.value > 0)
)

const genderOptions = ['女', '男', '保密']
const profileForm = reactive({
  displayName: '',
  familyName: '',
  givenName: '',
  gender: '',
  phone: '',
  birthday: '',
  avatar: ''
})
const profileErrors = reactive({})
const profileFeedback = ref('')
const profileSaving = ref(false)
const profileLoading = ref(false)
const avatarInputRef = ref(null)
const avatarUploading = ref(false)
const avatarPreviewUrl = ref('')
const selectedMerchantId = ref(null)
const storePicker = reactive({
  selectedId: null,
  returnTab: 'home'
})
const pickupOptions = [
  { value: 'DINE_IN', label: '店内享用', desc: '堂食慢慢品味' },
  { value: 'TAKEAWAY', label: '打包带走', desc: '到店自取更灵活' }
]
const pickupMethod = ref('TAKEAWAY')
const orderRemark = ref('')
const remarkEditorOpen = ref(false)
const checkoutFeedback = ref('')
const checkoutSubmitting = ref(false)
const geolocationSupported = typeof navigator !== 'undefined' && !!navigator.geolocation
const locationStatus = ref(geolocationSupported ? 'idle' : 'unsupported')
const userLocation = reactive({
  lat: null,
  lng: null
})

const isAdmin = computed(() => currentUser.value?.role === 'ADMIN')
const isMerchant = computed(() => currentUser.value?.role === 'MERCHANT')
const isCustomer = computed(() => currentUser.value?.role === 'CUSTOMER')
const showWorkbench = computed(() => isAdmin.value || isMerchant.value)
const merchantSnapshot = computed(() =>
  isMerchant.value
    ? {
        merchantName: merchantBoard.merchantName,
        received: merchantBoard.received,
        preparing: merchantBoard.preparing,
        ready: merchantBoard.ready,
        completed: merchantBoard.completed
      }
    : null
)

const merchantStatusOptions = [
  { value: 'OPEN', label: '正常营业' },
  { value: 'BUSY', label: '忙碌 · 控制接单' },
  { value: 'PAUSED', label: '暂停接单' }
]
const merchantStatus = ref('OPEN')
const merchantStatusNote = ref('')

const menuSlots = [
  { value: 'ALL_DAY', label: '全时段' },
  { value: 'MORNING', label: '上午档' },
  { value: 'NOON', label: '午后档' },
  { value: 'EVENING', label: '晚高峰' }
]

const dailyMenu = ref([])
const menuAlert = ref('')
const menuDraftById = reactive({})
const hasMenuStorage = typeof window !== 'undefined' && 'localStorage' in window
const getMenuStorageKey = (merchantId) => (merchantId ? `daily-menu-${merchantId}` : '')
const merchantHomeNotice = ref('')
const merchantRecommendationsHydrated = ref(false)
const recommendationSlots = [
  { key: 'dessert', label: '甜品推荐', category: 'DESSERT' },
  { key: 'classic', label: '经典咖啡', category: 'CLASSIC' },
  { key: 'pour', label: '手冲', category: 'POUR' },
  { key: 'special', label: '特调', category: 'SIGNATURE' }
]
const merchantRecommendations = reactive({
  dessert: '',
  classic: '',
  pour: '',
  special: ''
})
const defaultStorefrontBanners = () => [
  { id: 'banner-hero', imageUrl: brandLogo, caption: '门店晨间主推' },
  { id: 'banner-signature', imageUrl: profileBg, caption: '招牌特调' }
]
const storefrontBanners = ref(defaultStorefrontBanners())
const merchantCarousel = ref([])
const merchantCarouselLoading = ref(false)
const newCarousel = reactive({ imageUrl: '', caption: '' })
const newMenuDraft = reactive({
  drinkId: '',
  target: 20,
  slot: 'ALL_DAY'
})
let menuAlertTimer = null
let merchantHomeNoticeTimer = null
const productImageUploading = ref(false)
const carouselImageUploading = ref(false)
const productSaving = ref(false)

const adminKpis = computed(() => {
  const overview = adminOverview.value || {}
  return [
    { label: '饮品数', value: formatCount(overview.drinkCount), desc: '在售 SKU', highlight: false },
    { label: '门店数', value: formatCount(overview.merchantCount), desc: '已上线门店', highlight: false },
    { label: '累计订单', value: formatCount(overview.orderCount), desc: '总履约量', highlight: false },
    { label: '注册用户', value: formatCount(overview.userCount), desc: '会员池规模', highlight: false },
    {
      label: '人气饮品',
      value: overview.topDrink || orderOverview.value?.topDrink || '探索 8AM 风味',
      desc: '24 小时榜单',
      highlight: true
    }
  ]
})

const adminPipeline = computed(() => {
  const summary = orderOverview.value || {}
  const base = [
    { key: 'RECEIVED', label: '待接单', raw: Number(summary.received) || 0, desc: '待分配到门店' },
    { key: 'PREPARING', label: '制作中', raw: Number(summary.preparing) || 0, desc: '吧台正在制作' },
    { key: 'READY', label: '待取餐', raw: Number(summary.ready) || 0, desc: '等待顾客到店' },
    { key: 'COMPLETED', label: '已完成', raw: Number(summary.completed) || 0, desc: '已核销订单' }
  ]
  const total = base.reduce((sum, stage) => sum + stage.raw, 0) || 1
  return base.map((stage) => ({
    key: stage.key,
    label: stage.label,
    value: formatCount(stage.raw),
    desc: stage.desc,
    ratio: Math.round((stage.raw / total) * 100)
  }))
})

const adminFocus = computed(() => {
  const pipeline = adminPipeline.value
  if (!pipeline.length) {
    return {
      title: '等待数据同步',
      desc: '数据同步完成后会自动更新今日焦点。'
    }
  }
  const busiest = pipeline.reduce((prev, curr) => ((curr.ratio || 0) > (prev.ratio || 0) ? curr : prev), pipeline[0])
  const focusDrink = adminOverview.value?.topDrink || orderOverview.value?.topDrink || '灵感新饮'
  return {
    title: `${focusDrink}`,
    desc: `当前「${busiest.label}」阶段占比 ${busiest.ratio}% ，建议结合 ${focusDrink} 的物料规划。`
  }
})

const adminAutomationHint = computed(() => {
  const pipeline = adminPipeline.value
  if (!pipeline.length) {
    return '自动建议：完成基础数据同步后即可获得排队提示。'
  }
  const busiest = pipeline.reduce((prev, curr) => ((curr.ratio || 0) > (prev.ratio || 0) ? curr : prev), pipeline[0])
  return `自动建议：优先疏导「${busiest.label}」阶段，保持履约顺畅。`
})

const merchantStatusLabel = computed(
  () => merchantStatusOptions.find((item) => item.value === merchantStatus.value)?.label || '正常营业'
)

const merchantAlerts = computed(() => {
  if (merchantStatus.value === 'PAUSED') return '暂停接单中'
  if (merchantStatus.value === 'BUSY') return '忙碌，适当控单'
  const pending = Number(merchantBoard.received || 0) + Number(merchantBoard.preparing || 0)
  return pending > 6 ? '待接单较多，关注产能' : '运行正常'
})

const productLibraryByCategory = computed(() => {
  const groups = {}
  productCategories.forEach((cat) => {
    groups[cat.value] = []
  })
  productLibrary.value.forEach((item, index) => {
    const category = normalizeCategory(item.category || item.type || productCategories[index % productCategories.length].value)
    const normalized = {
      ...item,
      category
    }
    const bucket = groups[category] || (groups[category] = [])
    bucket.push(normalized)
  })
  Object.values(groups).forEach((list) =>
    list.sort((a, b) => a.name.localeCompare(b.name, 'zh-CN'))
  )
  return groups
})

const ensureMenuDraft = (drink) => {
  const key = String(drink.id)
  if (!menuDraftById[key]) {
    menuDraftById[key] = {
      slot: menuSlots[0].value,
      target: 20
    }
  }
  return menuDraftById[key]
}

const menuSearch = ref('')
const menuShowSelectedOnly = ref(false)
const menuPanelState = reactive({})

const ensureMenuPanels = () => {
  productCategories.forEach((cat, index) => {
    if (typeof menuPanelState[cat.value] === 'undefined') {
      menuPanelState[cat.value] = index === 0
    }
  })
}
ensureMenuPanels()

const categoryLabel = (category) =>
  productCategories.find((cat) => cat.value === normalizeCategory(category))?.label || '灵感饮品'

const unitLabelMap = {
  DESSERT: '份'
}

const unitLabelForCategory = (category) => unitLabelMap[normalizeCategory(category)] || '杯'

const inferCategoryFromDrinkId = (drinkId) => {
  const matched = productLibrary.value.find((drink) => String(drink.id) === String(drinkId))
  if (matched) {
    return normalizeCategory(
      matched.category || matched.type || productCategories[0].value
    )
  }
  return productCategories[0].value
}

const unitLabelForItem = (item) => {
  if (!item) return '杯'
  const category = normalizeCategory(
    item.category || inferCategoryFromDrinkId(item.drinkId)
  )
  return item.unitLabel || unitLabelForCategory(category)
}

const decorateMenuItem = (item, categoryHint) => {
  if (!item) return item
  const category = normalizeCategory(
    categoryHint || item.category || inferCategoryFromDrinkId(item.drinkId)
  )
  item.category = category
  item.unitLabel = unitLabelForCategory(category)
  return item
}

const menuUnitLabel = (item) => unitLabelForItem(item)

const persistDailyMenu = () => {
  const merchantId = Number(selectedMerchantId.value || currentUser.value?.merchantId)
  if (!hasMenuStorage || !merchantId) return
  try {
    window.localStorage.setItem(getMenuStorageKey(merchantId), JSON.stringify(dailyMenu.value))
  } catch {
    // ignore storage failures
  }
}

const restoreDailyMenu = (merchantId) => {
  if (!merchantId) {
    dailyMenu.value = []
    return
  }
  if (!hasMenuStorage) return
  try {
    const raw = window.localStorage.getItem(getMenuStorageKey(merchantId))
    const parsed = raw ? JSON.parse(raw) : []
    dailyMenu.value = parsed.map((item) => decorateMenuItem(item))
  } catch {
    dailyMenu.value = []
  }
}

const menuStats = computed(() => {
  const target = dailyMenu.value.reduce((sum, item) => sum + Number(item.target || 0), 0)
  const sold = dailyMenu.value.reduce((sum, item) => sum + Number(item.sold || 0), 0)
  return {
    target,
    sold,
    remaining: Math.max(target - sold, 0)
  }
})

const isInDailyMenu = (drinkId) =>
  dailyMenu.value.some((item) => String(item.drinkId) === String(drinkId))

const filteredMenuBuckets = computed(() => {
  const keyword = menuSearch.value.trim().toLowerCase()
  const showOnly = menuShowSelectedOnly.value
  const buckets = {}
  productCategories.forEach((cat) => {
    buckets[cat.value] = []
  })
  productLibrary.value.forEach((item) => {
    const normalizedCategory = normalizeCategory(item.category)
    if (showOnly && !isInDailyMenu(item.id)) return
    if (keyword && !item.name.toLowerCase().includes(keyword)) return
    ensureMenuDraft(item)
    const bucket = buckets[normalizedCategory] || (buckets[normalizedCategory] = [])
    bucket.push(item)
  })
  return buckets
})

const toggleMenuPanel = (categoryValue) => {
  menuPanelState[categoryValue] = !menuPanelState[categoryValue]
}

const syncMenuToProducts = () => {
  const map = {}
  dailyMenu.value.forEach((entry) => {
    map[String(entry.drinkId)] = entry
  })
  productLibrary.value.forEach((drink) => {
    const entry = map[String(drink.id)]
    const remaining = entry ? Math.max(Number(entry.target || 0) - Number(entry.sold || 0), 0) : 0
    drink.remaining = remaining
    drink.available = Boolean(entry && entry.status !== 'PAUSED' && remaining > 0)
    drink.menuSlot = entry?.slot || null
  })
}

watch(
  () => productLibrary.value,
  (list) => {
    ;(list || []).forEach((drink) => ensureMenuDraft(drink))
    ensureMenuPanels()
    syncMenuToProducts()
  },
  { immediate: true }
)

watch(
  dailyMenu,
  () => {
    syncMenuToProducts()
    persistDailyMenu()
  },
  { deep: true }
)

const merchantOrderStages = computed(() => {
  const mapping = [
    { key: 'received', label: '待接单', value: merchantBoard.received, desc: '等待确认' },
    { key: 'preparing', label: '制作中', value: merchantBoard.preparing, desc: '吧台制作' },
    { key: 'ready', label: '待取餐', value: merchantBoard.ready, desc: '提醒顾客到店' },
    { key: 'completed', label: '已完成', value: merchantBoard.completed, desc: '今日出杯' }
  ]
  return mapping.map((stage) => ({
    key: stage.key,
    label: stage.label,
    value: formatCount(stage.value || 0),
    desc: stage.desc
  }))
})

const recommendationOptions = computed(() => {
  const baseList = dailyMenu.value.length ? dailyMenu.value : productLibrary.value
  const libraryIndex = new Map(
    productLibrary.value.map((drink) => [String(drink.id), drink])
  )
  const seen = new Set()
  return baseList
    .map((entry) => {
      const referenceId = String(entry.drinkId || entry.id || '')
      const matched = libraryIndex.get(referenceId)
      const resolved = matched || entry
      const category = normalizeCategory(
        resolved.category || resolved.type || entry.category || productCategories[0].value
      )
      const name = resolved.name || entry.name
      if (!name) return null
      if (seen.has(name)) return null
      seen.add(name)
      return {
        id: resolved.id || entry.drinkId || entry.id || name,
        name,
        category
      }
    })
    .filter(Boolean)
})

const recommendationOptionsBySlot = computed(() => {
  const grouped = {}
  recommendationSlots.forEach((slot) => {
    const category = normalizeCategory(slot.category || '')
    grouped[slot.key] = recommendationOptions.value.filter((item) => item.category === category)
  })
  return grouped
})

const heroGreeting = computed(() =>
  currentUser.value ? `您好，${currentUser.value.displayName}` : '欢迎来到 8AM 灵感室'
)

const heroSubtitle = computed(() =>
  currentUser.value ? `角色 · ${roleLabel(currentUser.value.role)}` : '游客模式 · 浏览精选内容'
)

const customerPoints = computed(() => Math.max(Number(currentUser.value?.points) || 0, 0))
const currentMembershipTier = computed(() => resolveMembershipTier(currentUser.value?.membershipLevel))
const nextMembershipTier = computed(() =>
  membershipTiers.find((tier) => tier.threshold > customerPoints.value) || null
)
const membershipLabel = computed(() => currentUser.value?.membershipLabel || currentMembershipTier.value.label)

const membershipCode = computed(() =>
  currentUser.value?.id ? String(currentUser.value.id).padStart(6, '0') : '------'
)

const membershipCopy = computed(() => {
  if (!currentUser.value) {
    return '欢迎加入 8AM 灵感室'
  }
  const base = new Date(2024, 0, 1)
  const offset = currentUser.value.id ? currentUser.value.id % 160 : 0
  base.setDate(base.getDate() + offset)
  const month = String(base.getMonth() + 1).padStart(2, '0')
  const day = String(base.getDate()).padStart(2, '0')
  const venue = currentUser.value.merchantName || '8AM 灵感室'
  return `${base.getFullYear()}-${month}-${day} 成为 ${venue} 会员`
})

const profileInitial = computed(() =>
  profileForm.displayName
    ? profileForm.displayName.slice(0, 1)
    : currentUser.value?.displayName?.slice(0, 1) || '访'
)
const avatarDisplay = computed(() => avatarPreviewUrl.value || profileForm.avatar || '')
const profileAvatar = computed(() => {
  if (avatarPreviewUrl.value) return avatarPreviewUrl.value
  if (profileForm.avatar) return profileForm.avatar
  return currentUser.value?.avatar || ''
})
const profileBanner = computed(
  () =>
    currentUser.value?.banner || profileBg
)
const locationStatusText = computed(() => {
  switch (locationStatus.value) {
    case 'pending':
      return '定位中，请稍候'
    case 'ready':
      return '已根据当前位置推荐'
    case 'denied':
      return '未授权定位，可手动选择'
    case 'error':
      return '定位失败，可手动选择'
    case 'unsupported':
      return '设备不支持定位'
    default:
      return '可开启定位以按距离排序'
  }
})
const locationButtonLabel = computed(() => {
  if (!geolocationSupported) return '设备不支持定位'
  if (locationStatus.value === 'pending') return '定位中...'
  if (locationStatus.value === 'ready') return '重新定位'
  if (locationStatus.value === 'denied') return '重新授权定位'
  if (locationStatus.value === 'error') return '重新定位'
  return '开启定位'
})
const sortedMerchants = computed(() => {
  const lat = userLocation.lat
  const lng = userLocation.lng
  const list = merchants.value.map((store) => {
    let distance = null
    if (
      lat !== null &&
      lng !== null &&
      store.latitude !== undefined &&
      store.latitude !== null &&
      store.longitude !== undefined &&
      store.longitude !== null
    ) {
      distance = distanceBetween(lat, lng, store.latitude, store.longitude)
    }
    return {
      ...store,
      distance
    }
  })
  return list.sort((a, b) => {
    if (a.distance !== null && b.distance !== null) {
      return a.distance - b.distance
    }
    if (a.distance !== null) return -1
    if (b.distance !== null) return 1
    return a.name.localeCompare(b.name)
  })
})

const selectedMerchant = computed(() =>
  merchants.value.find((store) => String(store.id) === String(selectedMerchantId.value)) || null
)
const pickupMethodText = computed(
  () => pickupOptions.find((option) => option.value === pickupMethod.value)?.desc || '选择你偏好的取餐方式'
)
const pickupMethodLabel = computed(
  () => pickupOptions.find((option) => option.value === pickupMethod.value)?.label || '自取带走'
)
const orderContactName = computed(
  () => profileForm.displayName || currentUser.value?.displayName || currentUser.value?.username || ''
)
const orderContactPhone = computed(() => profileForm.phone || currentUser.value?.phone || '')
const checkoutDisabled = computed(
  () =>
    checkoutSubmitting.value ||
    !currentUser.value ||
    !sharedCartItems.value.length ||
    !selectedMerchantId.value ||
    !orderContactPhone.value
)

const profileHighlights = computed(() => {
  if (isMerchant.value) {
    const pending = Number(merchantBoard.received || 0) + Number(merchantBoard.preparing || 0)
    return [
      {
        label: '今日进行中',
        value: formatCount(pending),
        desc: '待接单 + 制作中'
      },
      {
        label: '已完成',
        value: formatCount(merchantBoard.completed || 0),
        desc: '今日出杯'
      },
      {
        label: '上架品类',
        value: dailyMenu.value.length + ' 款',
        desc: '今日菜单'
      }
    ]
  }
  if (isAdmin.value) {
    return [
      {
        label: '系统身份',
        value: roleLabel('ADMIN'),
        desc: '具备后台全部权限'
      },
      {
        label: '可管门店',
        value: merchants.value.length ? `${merchants.value.length} 家` : '—',
        desc: '可在“商家管理”维护'
      },
      {
        label: '待审批',
        value: formatCount(pendingMerchantRequests.value.length),
        desc: '新的入驻申请'
      }
    ]
  }
  const points = customerPoints.value
  const tier = currentMembershipTier.value
  const nextTier = nextMembershipTier.value
  const remaining = nextTier ? Math.max(nextTier.threshold - points, 0) : 0
  return [
    {
      label: '当前等级',
      value: tier.label,
      desc: nextTier ? `下一等级：${nextTier.label}` : '已达最高等级'
    },
    {
      label: '累计积分',
      value: formatCount(points),
      desc: nextTier ? `距升级还差 ${formatCount(remaining)} 分` : '继续保持即可获得更多惊喜'
    },
    {
      label: '下一等级',
      value: nextTier ? nextTier.label : '已满级',
      desc: nextTier ? `达成 ${formatCount(nextTier.threshold)} 分即升级` : '享受全部会员特权'
    }
  ]
})

const customerProfileActions = [
  { key: 'orders', icon: '🧾', label: '订单中心', desc: '查看制作进度与历史' },
  { key: 'info', icon: '👤', label: '个人资料', desc: '昵称、手机号与生日' },
  { key: 'about', icon: '✦', label: '关于我们', desc: '品牌故事与灵感' }
]
const merchantProfileActions = [
  { key: 'workbench', icon: '🧰', label: '门店工作台', desc: '管理今日商品与订单' },
  { key: 'carousel', icon: '🖼️', label: '轮播与推荐', desc: '配置顾客端首页内容' },
  { key: 'status', icon: '📣', label: '营业状态', desc: '更新营业提示与公告' }
]
const profileActions = computed(() => (isMerchant.value ? merchantProfileActions : customerProfileActions))

const handleProfileAction = (key) => {
  if (isMerchant.value) {
    handleMerchantProfileAction(key)
    return
  }
  if (key === 'orders') {
    activeTab.value = 'order'
    return
  }
  if (!currentUser.value) {
    authFeedback.value = '登录后即可使用该功能'
    setAuthMode('login')
    return
  }
  switch (key) {
    case 'info':
      profileFeedback.value = ''
      activeTab.value = 'profileSettings'
      ensureProfileHydrated()
      break
    case 'about':
      authFeedback.value = '8AM 实验室 · 咖啡巴斯克'
      break
    default:
      break
  }
}

const slotLabel = (slot) => menuSlots.find((item) => item.value === slot)?.label || '全时段'
const menuProgress = (item) => {
  if (!item?.target) return 0
  return Math.min(Math.round((Number(item.sold || 0) / Number(item.target)) * 100), 100)
}

const resetMenuDraft = () => {
  newMenuDraft.drinkId = ''
  newMenuDraft.target = 20
  newMenuDraft.slot = 'ALL_DAY'
}

const resetProductForm = () => {
  productForm.id = null
  productForm.category = productCategories[0].value
  productForm.name = ''
  productForm.price = ''
  productForm.description = ''
  productForm.imageUrl = ''
  productForm.tag = ''
  productForm.available = true
  assignOptionSettings(productForm.category)
  Object.keys(productErrors).forEach((key) => delete productErrors[key])
}

const resetMerchantHomeState = () => {
  merchantStatus.value = 'OPEN'
  merchantStatusNote.value = ''
  dailyMenu.value = []
  menuAlert.value = ''
  if (menuAlertTimer) {
    clearTimeout(menuAlertTimer)
    menuAlertTimer = null
  }
  resetMenuDraft()
  merchantCarousel.value = []
  resetCarouselDraft()
  merchantHomeNotice.value = ''
  storefrontBanners.value = defaultStorefrontBanners()
  if (merchantHomeNoticeTimer) {
    clearTimeout(merchantHomeNoticeTimer)
    merchantHomeNoticeTimer = null
  }
  Object.keys(merchantRecommendations).forEach((key) => {
    merchantRecommendations[key] = ''
  })
  merchantRecommendationsHydrated.value = false
  resetProductForm()
}

const showMenuAlert = (message) => {
  menuAlert.value = message
  if (menuAlertTimer) {
    clearTimeout(menuAlertTimer)
  }
  menuAlertTimer = setTimeout(() => {
    menuAlert.value = ''
    menuAlertTimer = null
  }, 2500)
}

const hydrateDailyMenu = () => {
  if (!isMerchant.value) return
  if (!productLibrary.value.length) return
  if (!dailyMenu.value.length) {
    dailyMenu.value = productLibrary.value.slice(0, 4).map((drink, index) =>
      decorateMenuItem(
        {
          id: `${drink.id}-${Date.now()}-${index}`,
          drinkId: drink.id,
          name: drink.name,
          slot: menuSlots[index % menuSlots.length].value,
          target: 20 + index * 5,
          sold: 0,
          status: 'ACTIVE'
        },
        drink.category
      )
    )
  }
  productLibrary.value.forEach((drink) => ensureMenuDraft(drink))
}

const toggleDailyMenuItem = (drink) => {
  const exists = dailyMenu.value.find((item) => String(item.drinkId) === String(drink.id))
  if (exists) {
    dailyMenu.value = dailyMenu.value.filter((item) => String(item.drinkId) !== String(drink.id))
    showMenuAlert(`已从今日菜单移除 ${drink.name}`)
    return
  }
  const draft = ensureMenuDraft(drink)
  dailyMenu.value.push(
    decorateMenuItem(
      {
        id: `${drink.id}-${Date.now()}`,
        drinkId: drink.id,
        name: drink.name,
        slot: draft.slot,
        target: Math.max(Number(draft.target) || 20, 5),
        sold: 0,
        status: 'ACTIVE'
      },
      drink.category
    )
  )
  showMenuAlert(`已上架 ${drink.name}`)
}

const remainingByItem = (drinkId) => {
  const item = dailyMenu.value.find((entry) => String(entry.drinkId) === String(drinkId))
  if (!item) return 0
  return Math.max(Number(item.target || 0) - Number(item.sold || 0), 0)
}

const statusLabelByItem = (drinkId) => {
  const item = dailyMenu.value.find((entry) => String(entry.drinkId) === String(drinkId))
  if (!item) return '未上架'
  return item.status === 'ACTIVE' ? '正常售卖' : '暂停'
}

const clearDailyMenu = () => {
  dailyMenu.value = []
  showMenuAlert('今日菜单已清空')
}

const adjustMenuTarget = (item, delta) => {
  const next = Math.max(Number(item.target || 0) + delta, Number(item.sold || 0), 0)
  item.target = next
}

const recordMenuSale = (item, qty = 1) => {
  if (!qty) return
  const next = Math.min(Number(item.target || 0), Number(item.sold || 0) + qty)
  item.sold = next
  showMenuAlert(`已记录 ${item.name} 售出 ${qty} ${unitLabelForItem(item)}`)
}

const findMenuItemByOrder = (order) => {
  if (!order) return null
  const candidateIds = [
    order.drinkId,
    order.drink_id,
    order.productId,
    order.drink?.id
  ].filter((id) => id !== undefined && id !== null)
  for (const id of candidateIds) {
    const match = dailyMenu.value.find((entry) => String(entry.drinkId) === String(id))
    if (match) {
      return decorateMenuItem(match)
    }
  }
  if (order.drinkName) {
    const fallback = dailyMenu.value.find((entry) => entry.name === order.drinkName) || null
    return decorateMenuItem(fallback)
  }
  return null
}

const autoRecordOrderCompletion = (order) => {
  const item = findMenuItemByOrder(order)
  if (!item) return
  const qty = Math.max(Number(order?.quantity) || 1, 1)
  const next = Math.min(Number(item.target || 0), Number(item.sold || 0) + qty)
  if (next === Number(item.sold || 0)) return
  item.sold = next
}

const toggleMenuAvailability = (item) => {
  item.status = item.status === 'ACTIVE' ? 'PAUSED' : 'ACTIVE'
}

const resetCarouselDraft = () => {
  newCarousel.imageUrl = ''
  newCarousel.caption = ''
}

const setMerchantHomeNotice = (message) => {
  merchantHomeNotice.value = message
  if (merchantHomeNoticeTimer) {
    clearTimeout(merchantHomeNoticeTimer)
  }
  merchantHomeNoticeTimer = setTimeout(() => {
    merchantHomeNotice.value = ''
    merchantHomeNoticeTimer = null
  }, 2500)
}

const normalizeMerchantBanner = (banner, index = 0) => {
  if (!banner) return null
  const normalizedPath = sanitizeAssetPath(banner.imageUrl || '')
  return {
    id: banner.id || `banner-${Date.now()}-${index}`,
    merchantId: banner.merchantId || banner.merchant_id || null,
    displayOrder: banner.displayOrder ?? index,
    caption: banner.caption || '',
    imageUrl: normalizedPath ? buildAssetUrl(normalizedPath) : banner.imageUrl || ''
  }
}

const normalizeMerchantBannerList = (items) => {
  if (!Array.isArray(items)) return []
  return items
    .map((item, index) => normalizeMerchantBanner(item, index))
    .filter((item) => Boolean(item?.imageUrl))
}

const uploadMediaFile = async (file) => {
  const response = await uploadAsset(file)
  const rawUrl = response?.url || response?.data?.url || response?.path || ''
  const normalizedPath = sanitizeAssetPath(rawUrl)
  return buildAssetUrl(normalizedPath || rawUrl)
}

const handleProductImageUpload = async (event) => {
  const file = event?.target?.files?.[0]
  if (!file) return
  productImageUploading.value = true
  try {
    const imageUrl = await uploadMediaFile(file)
    if (!imageUrl) throw new Error('未返回图片地址')
    productForm.imageUrl = imageUrl
    setMerchantHomeNotice('图片上传成功')
  } catch (error) {
    const message = error.response?.data?.message || error.message || '图片上传失败，请稍后再试'
    setMerchantHomeNotice(message)
  } finally {
    productImageUploading.value = false
    if (event?.target) {
      event.target.value = ''
    }
  }
}

const handleCarouselImageUpload = async (event) => {
  const file = event?.target?.files?.[0]
  if (!file) return
  carouselImageUploading.value = true
  try {
    const imageUrl = await uploadMediaFile(file)
    if (!imageUrl) throw new Error('未返回图片地址')
    newCarousel.imageUrl = imageUrl
    setMerchantHomeNotice('轮播图上传成功')
  } catch (error) {
    const message = error.response?.data?.message || error.message || '轮播图上传失败，请稍后再试'
    setMerchantHomeNotice(message)
  } finally {
    carouselImageUploading.value = false
    if (event?.target) {
      event.target.value = ''
    }
  }
}

const sanitizeOptionGroup = (group, presets) => {
  const fallbackValue = presets[0]?.value || ''
  const options = presets.map((preset) => {
    const matched = group?.options?.find((opt) => opt.value === preset.value)
    return {
      value: preset.value,
      label: (matched?.label || preset.label || '').trim() || preset.label,
      visible: matched?.visible !== false
    }
  })
  const visible = options.filter((option) => option.visible)
  const defaultValue = visible.some((option) => option.value === group?.defaultValue)
    ? group.defaultValue
    : visible[0]?.value || fallbackValue
  return {
    enabled: Boolean(group?.enabled),
    defaultValue,
    options
  }
}

const buildOptionSettingsPayload = (category) => {
  const normalized = normalizeCategory(category)
  const sugar = sanitizeOptionGroup(productForm.optionSettings.sugar, sugarOptionPresets)
  const tableware = sanitizeOptionGroup(productForm.optionSettings.tableware, tablewareOptionPresets)
  const pourDemo = sanitizeOptionGroup(productForm.optionSettings.pourDemo, pourOptionPresets)
  if (normalized === 'DESSERT') {
    sugar.enabled = false
    tableware.enabled = true
    pourDemo.enabled = false
  } else if (normalized === 'POUR') {
    sugar.enabled = false
    tableware.enabled = false
    pourDemo.enabled = true
  } else if (['CLASSIC', 'SIGNATURE'].includes(normalized)) {
    sugar.enabled = true
    tableware.enabled = false
    pourDemo.enabled = false
  } else {
    sugar.enabled = false
    tableware.enabled = false
    pourDemo.enabled = false
  }
  return { sugar, tableware, pourDemo }
}

const validateProductForm = () => {
  const errors = {}
  if (!productForm.name.trim()) {
    errors.name = '请填写商品名称'
  }
  if (!productForm.price || Number(productForm.price) <= 0) {
    errors.price = '价格需大于 0'
  }
  return errors
}

const saveProduct = async () => {
  const errors = validateProductForm()
  Object.keys(productErrors).forEach((key) => delete productErrors[key])
  Object.assign(productErrors, errors)
  if (Object.keys(errors).length) return

  if (!currentUser.value?.merchantId) {
    setMerchantHomeNotice('请先以商家身份登录')
    return
  }

  const payload = {
    merchantId: currentUser.value.merchantId,
    category: normalizeCategory(productForm.category),
    name: productForm.name.trim(),
    price: Number(productForm.price),
    description: productForm.description.trim() || null,
    imageUrl: sanitizeAssetPath(productForm.imageUrl.trim()) || null,
    flavorProfile: productForm.tag.trim() || null,
    available: Boolean(productForm.available),
    optionSettings: buildOptionSettingsPayload(productForm.category)
  }

  productSaving.value = true
  try {
    if (productForm.id) {
      await updateMerchantProduct(productForm.id, payload)
      setMerchantHomeNotice(`已更新「${payload.name}」`)
    } else {
      await createMerchantProduct(payload)
      setMerchantHomeNotice(`已新增「${payload.name}」`)
    }
    await loadSharedResources(currentUser.value.merchantId)
    resetProductForm()
  } catch (error) {
    const message = error.response?.data?.message || '保存失败，请稍后再试'
    setMerchantHomeNotice(message)
  } finally {
    productSaving.value = false
  }
}

const editProduct = (product) => {
  if (!product) return
  productForm.id = product.id
  productForm.category = normalizeCategory(product.category)
  productForm.name = product.name || ''
  productForm.price = product.price ?? ''
  productForm.description = product.description || ''
  productForm.imageUrl = product.imageUrl || ''
  productForm.tag = product.tag || ''
  productForm.available = product.available !== false
  assignOptionSettings(productForm.category, product.optionSettings || null)
  Object.keys(productErrors).forEach((key) => delete productErrors[key])
}

const deleteProduct = async (target) => {
  const id = typeof target === 'object' ? target?.id : target
  if (!id) return
  const hint = typeof target === 'object' && target?.name ? `“${target.name}”` : '该商品'
  if (typeof window !== 'undefined' && !window.confirm(`确认删除${hint}吗？`)) {
    return
  }
  if (!currentUser.value?.merchantId) {
    setMerchantHomeNotice('请先登录商家账号')
    return
  }
  try {
    await deleteMerchantProduct(id, currentUser.value.merchantId)
    if (productForm.id === id) {
      resetProductForm()
    }
    await loadSharedResources(currentUser.value.merchantId)
    setMerchantHomeNotice('商品已删除')
  } catch (error) {
    const message = error.response?.data?.message || '删除失败，请稍后再试'
    setMerchantHomeNotice(message)
  }
}

const addCarouselItem = async () => {
  if (!newCarousel.imageUrl) return
  try {
    const payload = {
      imageUrl: newCarousel.imageUrl,
      caption: newCarousel.caption?.trim() || ''
    }
    const created = await createMerchantBanner(payload)
    const normalized = normalizeMerchantBanner(created, merchantCarousel.value.length)
    if (normalized) {
      merchantCarousel.value = [...merchantCarousel.value, normalized]
    }
    setMerchantHomeNotice('已新增轮播图片')
    if (
      currentUser.value?.merchantId &&
      String(currentUser.value.merchantId) === String(selectedMerchantId.value)
    ) {
      await loadStorefrontBanners(currentUser.value.merchantId)
    }
    resetCarouselDraft()
  } catch (error) {
    const message = error.response?.data?.message || '新增轮播失败，请稍后重试'
    setMerchantHomeNotice(message)
  }
}

const removeCarouselItem = async (id) => {
  if (!id) return
  try {
    await deleteMerchantBanner(id)
    merchantCarousel.value = merchantCarousel.value.filter((item) => item.id !== id)
    setMerchantHomeNotice('已删除轮播图片')
    if (
      currentUser.value?.merchantId &&
      String(currentUser.value.merchantId) === String(selectedMerchantId.value)
    ) {
      await loadStorefrontBanners(currentUser.value.merchantId)
    }
  } catch (error) {
    const message = error.response?.data?.message || '删除轮播失败，请稍后重试'
    setMerchantHomeNotice(message)
  }
}

const syncRecommendationsFromMenu = () => {
  const grouped = recommendationOptionsBySlot.value
  recommendationSlots.forEach((slot) => {
    const first = grouped[slot.key]?.[0]
    merchantRecommendations[slot.key] = first?.name || ''
  })
  merchantRecommendationsHydrated.value = true
  setMerchantHomeNotice('今日推荐已同步')
}

const announceStatus = () => {
  const note = merchantStatusNote.value.trim()
  const message = `已发送「${merchantStatusLabel.value}」营业通知${note ? `：${note}` : ''}`
  setMerchantHomeNotice(message)
}

const handleMerchantRequestAction = async (request, action) => {
  if (!request?.id) return
  if (merchantRequestProcessing.value === request.id) return
  merchantRequestProcessing.value = request.id
  try {
    if (action === 'approve') {
      await approveMerchantRequest(request.id)
      adminCommandFeedback.value = `已同意「${request.merchantName}」入驻申请`
    } else {
      await rejectMerchantRequest(request.id)
      adminCommandFeedback.value = `已驳回「${request.merchantName}」入驻申请`
    }
    await loadMerchantRequests()
  } catch (error) {
    adminCommandFeedback.value =
      error.response?.data?.message || (action === 'approve' ? '审批失败，请稍后重试' : '驳回失败，请稍后重试')
  } finally {
    merchantRequestProcessing.value = ''
  }
}

const handleApproveMerchantRequest = (request) => handleMerchantRequestAction(request, 'approve')
const handleRejectMerchantRequest = (request) => handleMerchantRequestAction(request, 'reject')

const handleMerchantProfileAction = (key) => {
  switch (key) {
    case 'workbench':
      activeTab.value = 'order'
      break
    case 'carousel':
      activeTab.value = 'home'
      setMerchantHomeNotice('已定位到轮播配置')
      break
    case 'status':
      announceStatus()
      break
    case 'logout':
      logout()
      break
    default:
      break
  }
}

const resetProfileForm = () => {
  profileForm.displayName = ''
  profileForm.familyName = ''
  profileForm.givenName = ''
  profileForm.gender = ''
  profileForm.phone = ''
  profileForm.birthday = ''
  profileForm.avatar = ''
  Object.keys(profileErrors).forEach((key) => delete profileErrors[key])
  profileFeedback.value = ''
}

const populateProfileForm = (user) => {
  if (!user) {
    resetProfileForm()
    return
  }
  profileForm.displayName = user.displayName || ''
  profileForm.familyName = user.familyName || ''
  profileForm.givenName = user.givenName || ''
  profileForm.gender = user.gender || ''
  profileForm.phone = user.phone || ''
  profileForm.avatar = user.avatar || ''
  profileForm.birthday = user.birthday || ''
}

const ensureProfileHydrated = async () => {
  if (!currentUser.value?.id) return
  profileLoading.value = true
  try {
    const fresh = await fetchUserProfile(currentUser.value.id)
    currentUser.value = fresh
    populateProfileForm(fresh)
  } catch (error) {
    profileFeedback.value = error.response?.data?.message || '加载资料失败，请稍后重试'
  } finally {
    profileLoading.value = false
  }
}

const revokePreviewUrl = (url) => {
  if (!url) return
  if (typeof URL !== 'undefined' && typeof URL.revokeObjectURL === 'function') {
    URL.revokeObjectURL(url)
  }
}

const clearAvatarPreview = () => {
  if (avatarPreviewUrl.value) {
    revokePreviewUrl(avatarPreviewUrl.value)
    avatarPreviewUrl.value = ''
  }
}

const clearAvatarInput = () => {
  const input = avatarInputRef.value
  if (input) {
    input.value = ''
  }
}

const triggerAvatarPicker = () => {
  if (!currentUser.value) {
    activeTab.value = 'profileLogin'
    return
  }
  if (avatarUploading.value) return
  profileFeedback.value = ''
  avatarInputRef.value?.click()
}

const handleAvatarFile = async (event) => {
  const input = event.target
  const files = input?.files
  if (!files?.length) return
  const file = files[0]
  if (!file.type?.startsWith('image/')) {
    profileFeedback.value = '请选择图片文件'
    clearAvatarInput()
    return
  }
  clearAvatarPreview()
  avatarPreviewUrl.value = URL.createObjectURL(file)
  avatarUploading.value = true
  profileFeedback.value = ''
  try {
    const response = await uploadAvatar(file)
    if (!response?.url) {
      throw new Error('missing url')
    }
    profileForm.avatar = response.url
    profileFeedback.value = '头像已上传，记得点击保存'
  } catch (error) {
    profileFeedback.value = error.response?.data?.message || '上传失败，请稍后再试'
  } finally {
    avatarUploading.value = false
    clearAvatarPreview()
    clearAvatarInput()
  }
}

const showProfileHints = () => {
  profileFeedback.value = '支持相册与拍摄上传，成功后记得保存资料'
}

const distanceBetween = (lat1, lon1, lat2, lon2) => {
  const toRad = (value) => (value * Math.PI) / 180
  const R = 6371
  const dLat = toRad(lat2 - lat1)
  const dLon = toRad(lon2 - lon1)
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  return R * c
}

const requestLocation = () => {
  if (!geolocationSupported) {
    locationStatus.value = 'unsupported'
    return
  }
  locationStatus.value = 'pending'
  navigator.geolocation.getCurrentPosition(
    (position) => {
      userLocation.lat = position.coords.latitude
      userLocation.lng = position.coords.longitude
      locationStatus.value = 'ready'
    },
    (error) => {
      if (error.code === error.PERMISSION_DENIED) {
        locationStatus.value = 'denied'
      } else {
        locationStatus.value = 'error'
      }
    },
    { enableHighAccuracy: true, timeout: 8000 }
  )
}

const checkoutThumbStyle = (item = {}) => {
  const image = item.imageUrl || item.image
  return {
    backgroundImage: image
      ? `linear-gradient(135deg, rgba(15,23,42,0.35), rgba(15,23,42,0.65)), url(${image})`
      : 'linear-gradient(135deg, rgba(15,23,42,0.35), rgba(15,23,42,0.65))',
    backgroundSize: 'cover',
    backgroundPosition: 'center'
  }
}

const openStorePicker = () => {
  storePicker.selectedId = selectedMerchantId.value || merchants.value[0]?.id || null
  storePicker.returnTab = activeTab.value || 'home'
  activeTab.value = 'storePicker'
  if (locationStatus.value === 'idle' && geolocationSupported) {
    requestLocation()
  }
}

const closeStorePicker = () => {
  activeTab.value = storePicker.returnTab || 'home'
}

const confirmStoreSelection = () => {
  if (!storePicker.selectedId) return
  selectedMerchantId.value = storePicker.selectedId
  const nextTab = showWorkbench.value ? 'order' : storePicker.returnTab || 'home'
  activeTab.value = nextTab
}

const enterCheckout = () => {
  if (showWorkbench.value) return
  if (!sharedCartItems.value.length) {
    checkoutFeedback.value = '购物车为空，去挑选喜欢的灵感饮品吧'
    activeTab.value = 'home'
    return
  }
  checkoutFeedback.value = ''
  activeTab.value = 'checkout'
}

const handleCheckoutSubmit = async () => {
  if (checkoutDisabled.value) return
  if (!currentUser.value) {
    checkoutFeedback.value = '请先登录后再下单'
    activeTab.value = 'profileLogin'
    return
  }
  if (!sharedCartItems.value.length) {
    checkoutFeedback.value = '购物车为空，去挑选喜欢的灵感饮品吧'
    activeTab.value = 'home'
    return
  }
  if (!selectedMerchantId.value) {
    checkoutFeedback.value = '请选择门店后再下单'
    openStorePicker()
    return
  }
  if (!orderContactPhone.value) {
    checkoutFeedback.value = '请先在“我的-个人资料”中完善手机号'
    handleProfileAction('info')
    return
  }
  checkoutSubmitting.value = true
  checkoutFeedback.value = ''
  try {
    const merchantId = Number(selectedMerchantId.value)
    const pickupNote = [pickupMethodLabel.value, orderRemark.value.trim()].filter(Boolean).join(' · ')
    const createdOrderIds = []
    for (const item of sharedCartItems.value) {
      const order = await createOrder({
        customerName: orderContactName.value || '灵感顾客',
        contactPhone: orderContactPhone.value,
        drinkId: Number(item.drinkId),
        merchantId,
        quantity: Number(item.quantity) || 1,
        pickupTime: pickupNote || pickupMethodLabel.value,
        userId: currentUser.value?.id || null,
        customSummary: item.customSummary || '',
        customizations: item.customizations || null
      })
      if (order?.id) {
        createdOrderIds.push(order.id)
      }
    }
    if (!createdOrderIds.length) {
      checkoutFeedback.value = '未能创建订单，请稍后再试'
      return
    }
    checkoutFeedback.value = '订单已创建，正在拉起支付宝'
    const paymentReturnUrl =
      typeof window !== 'undefined' ? `${window.location.origin}/` : undefined
    const payment = await createAlipayPayment({
      orderIds: createdOrderIds,
      returnUrl: paymentReturnUrl
    })
    if (payment?.payUrl && typeof window !== 'undefined') {
      const opened = window.open(payment.payUrl, '_blank', 'noopener')
      if (!opened) {
        window.location.href = payment.payUrl
      }
    }
    await loadSharedResources()
    orderRemark.value = ''
    remarkEditorOpen.value = false
    clearSharedCart()
    checkoutFeedback.value = '请在支付宝完成支付，稍后可在“我的-订单中心”查看进度'
    activeTab.value = 'home'
  } catch (error) {
    checkoutFeedback.value = error?.response?.data?.message || '下单或拉起支付失败，请稍后再试'
  } finally {
    checkoutSubmitting.value = false
  }
}

const validateProfileForm = () => {
  const errors = {}
  if (!profileForm.displayName) {
    errors.displayName = '请输入昵称'
  }
  return errors
}

const submitProfile = async () => {
  if (!currentUser.value?.id) {
    profileFeedback.value = '请先登录后再保存'
    return
  }
  const errors = validateProfileForm()
  Object.keys(profileErrors).forEach((key) => delete profileErrors[key])
  Object.assign(profileErrors, errors)
  if (Object.keys(errors).length) {
    return
  }
  profileSaving.value = true
  profileFeedback.value = ''
  try {
    const payload = {
      displayName: profileForm.displayName,
      familyName: profileForm.familyName || null,
      givenName: profileForm.givenName || null,
      gender: profileForm.gender || null,
      phone: profileForm.phone || null,
      birthday: profileForm.birthday || null,
      avatar: profileForm.avatar || null
    }
    const updated = await updateUserProfile(currentUser.value.id, payload)
    currentUser.value = updated
    populateProfileForm(updated)
    profileFeedback.value = '已保存'
  } catch (error) {
    profileFeedback.value = error.response?.data?.message || '保存失败，请稍后重试'
  } finally {
    profileSaving.value = false
  }
}

const validateAuth = () => {
  const errors = {}
  const username = authForm.username.trim()
  const password = authForm.password
  if (!username) {
    errors.username = '请填写用户名'
  } else if (!/^[a-zA-Z0-9_]{4,20}$/.test(username)) {
    errors.username = '用户名需为 4-20 位，仅限字母、数字或下划线'
  }
  if (!password) {
    errors.password = '请填写密码'
  } else if (
    authMode.value === 'register' &&
    !/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+\-=]{6,18}$/.test(password)
  ) {
    errors.password = '密码需 6-18 位，且同时包含字母和数字'
  }
  if (authMode.value === 'register') {
    const displayName = authForm.displayName.trim()
    if (!displayName) {
      errors.displayName = '请填写昵称'
    } else if (displayName.length < 2 || displayName.length > 20) {
      errors.displayName = '昵称需 2-20 个字符'
    }
    if (registerRole.value === 'MERCHANT' && !authForm.merchantId) {
      errors.merchantId = '请选择门店'
    }
  }
  return errors
}

const setAuthMode = (mode) => {
  authMode.value = mode
  authFeedback.value = ''
  Object.keys(authErrors).forEach((key) => delete authErrors[key])
}

const setLoginRole = (role) => {
  loginRole.value = role
  authFeedback.value = ''
}

const clearRegisterCooldown = () => {
  if (registerCooldownTimer) {
    clearInterval(registerCooldownTimer)
    registerCooldownTimer = null
  }
}

const startRegisterCooldown = () => {
  clearRegisterCooldown()
  registerCooldown.value = REGISTER_COOLDOWN_SECONDS
  registerCooldownTimer = setInterval(() => {
    registerCooldown.value -= 1
    if (registerCooldown.value <= 0) {
      registerCooldown.value = 0
      clearRegisterCooldown()
    }
  }, 1000)
}

onUnmounted(() => {
  clearRegisterCooldown()
})

const roleLabel = (role) => roles.find((item) => item.value === role)?.label || role

const applyAuthSession = (session) => {
  const user = session?.user || null
  authSessionToken.value = session?.token || ''
  setAuthToken(authSessionToken.value)
  currentUser.value = user
  return user
}

const submitAuth = async () => {
  if (authSubmitting.value) return
  if (authMode.value === 'register' && registerCooldown.value > 0) {
    authFeedback.value = `注册过于频繁，请 ${registerCooldown.value} 秒后再试`
    return
  }
  const errors = validateAuth()
  Object.keys(authErrors).forEach((key) => delete authErrors[key])
  Object.assign(authErrors, errors)
  if (Object.keys(errors).length) return
  authForm.username = authForm.username.trim()
  if (authMode.value === 'register') {
    authForm.displayName = authForm.displayName.trim()
  }

  try {
    authSubmitting.value = true
    if (authMode.value === 'register') {
      const payload = {
        username: authForm.username,
        displayName: authForm.displayName,
        password: authForm.password,
        role: registerRole.value
      }
      if (registerRole.value === 'MERCHANT') {
        payload.merchantId = authForm.merchantId
      }
      startRegisterCooldown()
      const response = await register(payload)
      if (registerRole.value !== 'CUSTOMER') {
        authFeedback.value = response?.message || '注册成功，请等待审核'
        authForm.password = ''
        setAuthMode('login')
        return
      }
      const user = applyAuthSession(response)
      if (user?.role) {
        loginRole.value = user.role
      }
      setAuthMode('login')
      authFeedback.value = '注册成功，可直接登录'
      authForm.password = ''
      if (user) {
        await afterAuth(user)
      }
      if (activeTab.value === 'profileLogin') {
        activeTab.value = 'profile'
      }
    } else {
      const payload = {
        username: authForm.username,
        password: authForm.password,
        role: loginRole.value
      }
      const session = await login(payload)
      const user = applyAuthSession(session)
      const greeting = user?.displayName || user?.username || '朋友'
      authFeedback.value = `欢迎回来，${greeting}`
      authForm.password = ''
      if (user) {
        await afterAuth(user)
      }
      if (activeTab.value === 'profileLogin') {
        activeTab.value = 'profile'
      }
    }
  } catch (error) {
    authFeedback.value = error.response?.data?.message || '操作失败，请稍后再试'
  } finally {
    authSubmitting.value = false
    authForm.password = ''
  }
}

const logout = () => {
  currentUser.value = null
  authSessionToken.value = ''
  setAuthToken('')
  loginRole.value = 'CUSTOMER'
  registerRole.value = 'CUSTOMER'
  authFeedback.value = ''
  adminActivePanel.value = adminPanels[0].key
  adminCommandFeedback.value = ''
  if (activeTab.value === 'profileLogin') {
    activeTab.value = 'profile'
  }
  resetProfileForm()
  selectedMerchantId.value = null
  storePicker.selectedId = null
  storePicker.returnTab = 'home'
  resetMerchantHomeState()
  adminOverview.value = null
  merchantBoard.merchantName = ''
  merchantBoard.received = 0
  merchantBoard.preparing = 0
  merchantBoard.ready = 0
  merchantBoard.completed = 0
  merchantBoard.orders = []
  merchantRequests.value = []
  merchantRequestsError.value = ''
  merchantRequestProcessing.value = ''
}

const loadAdminResources = async () => {
  if (!isAdmin.value) return
  adminOverview.value = await fetchAdminOverview()
}

const loadMerchantRequests = async () => {
  if (!isAdmin.value) return
  merchantRequestsLoading.value = true
  merchantRequestsError.value = ''
  try {
    const response = await fetchMerchantRequests()
    const list = Array.isArray(response?.items)
      ? response.items
      : Array.isArray(response)
        ? response
        : response?.data || []
    merchantRequests.value = list.map((item) => normalizeMerchantRequest(item))
  } catch (error) {
    merchantRequestsError.value = error.response?.data?.message || '加载商家申请失败，请稍后重试'
  } finally {
    merchantRequestsLoading.value = false
  }
}

const loadMerchantBoard = async () => {
  if (!isMerchant.value || !currentUser.value?.merchantId) {
    merchantBoard.merchantName = ''
    merchantBoard.received = 0
    merchantBoard.preparing = 0
    merchantBoard.ready = 0
    merchantBoard.completed = 0
    merchantBoard.orders = []
    return
  }
  const snapshot = await fetchMerchantOrders(currentUser.value.merchantId)
  merchantBoard.merchantName = snapshot.merchantName
  merchantBoard.received = snapshot.received
  merchantBoard.preparing = snapshot.preparing
  merchantBoard.ready = snapshot.ready
  merchantBoard.completed = snapshot.completed
  merchantBoard.orders = snapshot.orders
}

const loadMerchantCarousel = async () => {
  if (!isMerchant.value || !currentUser.value?.merchantId) {
    merchantCarousel.value = []
    return
  }
  merchantCarouselLoading.value = true
  try {
    const response = await listMerchantBanners()
    const list = Array.isArray(response?.items) ? response.items : response
    merchantCarousel.value = normalizeMerchantBannerList(list || [])
  } catch (error) {
    const message = error.response?.data?.message || '加载轮播图失败，请稍后重试'
    setMerchantHomeNotice(message)
  } finally {
    merchantCarouselLoading.value = false
  }
}

const loadStorefrontBanners = async (merchantId) => {
  const targetId = merchantId ? Number(merchantId) : null
  if (!targetId) {
    storefrontBanners.value = defaultStorefrontBanners()
    return
  }
  try {
    const response = await fetchMerchantBanners(targetId)
    const list = Array.isArray(response?.items) ? response.items : response
    const normalized = normalizeMerchantBannerList(list || [])
    storefrontBanners.value = normalized.length ? normalized : defaultStorefrontBanners()
  } catch (error) {
    console.error('加载门店轮播失败', error)
    storefrontBanners.value = defaultStorefrontBanners()
  }
}

const loadSharedResources = async (merchantId = selectedMerchantId.value) => {
  const targetId = merchantId ? Number(merchantId) : null
  if (targetId) {
    const [drinks, bannerPayload] = await Promise.all([
      fetchCatalogDrinks({ merchantId: targetId }),
      fetchMerchantBanners(targetId).catch((error) => {
        console.error('加载门店轮播失败', error)
        return []
      })
    ])
    productLibrary.value = drinks.map((drink, index) => {
      const category = normalizeCategory(
        drink.category || drink.type || productCategories[index % productCategories.length].value
      )
      const canonicalImage = sanitizeAssetPath(drink.imageUrl || '')
      return {
        ...drink,
        imageUrl: canonicalImage ? buildAssetUrl(canonicalImage) : drink.imageUrl || '',
        imagePath: canonicalImage || drink.imageUrl || '',
        category,
        unitLabel: unitLabelForCategory(category),
        tag: drink.flavorProfile || drink.tag || '',
        available: drink.available !== false,
        optionSettings: drink.optionSettings || null
      }
    })
    restoreDailyMenu(targetId)
    const bannerResponse = Array.isArray(bannerPayload?.items) ? bannerPayload.items : bannerPayload
    const normalizedBanners = normalizeMerchantBannerList(bannerResponse || [])
    storefrontBanners.value = normalizedBanners.length ? normalizedBanners : defaultStorefrontBanners()
  } else {
    productLibrary.value = []
    dailyMenu.value = []
    storefrontBanners.value = defaultStorefrontBanners()
  }
  syncMenuToProducts()
  merchants.value = await fetchMerchants()
  orderOverview.value = await fetchOrderOverview()
  if (registerRole.value === 'MERCHANT' && merchants.value.length && !authForm.merchantId) {
    authForm.merchantId = merchants.value[0].id
  }
}

const refreshMerchantsOnly = async () => {
  try {
    merchants.value = await fetchMerchants()
  } catch (error) {
    console.error('刷新门店列表失败', error)
  }
}

const afterAuth = async (user) => {
  if (user.role === 'ADMIN') {
    await Promise.all([loadAdminResources(), loadMerchantRequests()])
  }
  if (user.role === 'MERCHANT') {
    if (user.merchantId) {
      selectedMerchantId.value = user.merchantId
      try {
        await loadSharedResources(user.merchantId)
      } catch (error) {
        console.error('加载门店商品失败', error)
      }
    }
    await loadMerchantBoard()
    await loadMerchantCarousel()
  }
}

const submitCustomerOrder = async (payload) => {
  await createOrder({
    ...payload,
    drinkId: Number(payload.drinkId),
    merchantId: Number(payload.merchantId),
    userId: currentUser.value?.id || null
  })
  await loadMerchantBoard()
  await loadSharedResources(selectedMerchantId.value)
}

const changeOrderStatus = async (orderId, status, orderDetail = null) => {
  if (!currentUser.value?.merchantId) return
  await updateMerchantOrderStatus(currentUser.value.merchantId, orderId, status)
  if (status === 'COMPLETED' && orderDetail) {
    autoRecordOrderCompletion(orderDetail)
  }
  await loadMerchantBoard()
}

const statusLabel = (status) => {
  switch (status) {
    case 'RECEIVED':
      return '已接单'
    case 'PREPARING':
      return '制作中'
    case 'READY':
      return '待取杯'
    case 'COMPLETED':
      return '已完成'
    default:
      return status
  }
}

const nextStatuses = (status) => {
  const transitions = {
    RECEIVED: [{ code: 'PREPARING', label: '开始制作' }],
    PREPARING: [
      { code: 'READY', label: '制作完成' }
    ],
    READY: [{ code: 'COMPLETED', label: '完成取杯' }],
    COMPLETED: []
  }
  return transitions[status] || []
}

const formatTime = (isoString) => {
  if (!isoString) return '--'
  const date = new Date(isoString)
  const year = date.getFullYear()
  const month = (date.getMonth() + 1).toString().padStart(2, '0')
  const day = date.getDate().toString().padStart(2, '0')
  const hours = date.getHours().toString().padStart(2, '0')
  const minutes = date.getMinutes().toString().padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}`
}

watch(
  () => productLibrary.value.length,
  () => {
    if (isMerchant.value) {
      hydrateDailyMenu()
      if (!merchantRecommendationsHydrated.value && recommendationOptions.value.length) {
        syncRecommendationsFromMenu()
      }
    }
  }
)

watch(
  () => isMerchant.value,
  (flag) => {
    if (flag) {
      hydrateDailyMenu()
      if (recommendationOptions.value.length) {
        syncRecommendationsFromMenu()
      }
    } else {
      resetMerchantHomeState()
    }
  }
)

watch(
  () => dailyMenu.value.length,
  () => {
    if (isMerchant.value && !merchantRecommendationsHydrated.value && recommendationOptions.value.length) {
      syncRecommendationsFromMenu()
    }
  }
)

watch(
  () => currentUser.value,
  (user) => {
    populateProfileForm(user)
    if (!user) {
      profileLoading.value = false
    }
  },
  { immediate: true }
)

watch(
  () => activeTab.value,
  (tab) => {
    if (tab === 'profileSettings' && currentUser.value?.id) {
      ensureProfileHydrated()
    }
    if (tab !== 'profileSettings') {
      profileSaving.value = false
    }
  }
)

watch(
  () => registerRole.value,
  (role) => {
    if (role !== 'MERCHANT') {
      authForm.merchantId = ''
    } else if (!authForm.merchantId && merchants.value.length) {
      authForm.merchantId = merchants.value[0].id
    }
  }
)

watch(
  () => selectedMerchantId.value,
  async (merchantId, previous) => {
    if (merchantId === previous) {
      return
    }
    try {
      await loadSharedResources(merchantId || undefined)
    } catch (error) {
      console.error('Failed to refresh catalog for merchant', error)
    }
  }
)

watch(
  () => currentUser.value?.merchantId,
  (merchantId) => {
    if (!merchantId) return
    if (String(selectedMerchantId.value) !== String(merchantId)) {
      selectedMerchantId.value = merchantId
    }
    loadMerchantCarousel()
  }
)

watch(
  () => currentUser.value?.role,
  async (role) => {
    if (role === 'ADMIN') {
      await Promise.all([loadAdminResources(), loadMerchantRequests()])
    } else if (role === 'MERCHANT') {
      await Promise.all([loadMerchantBoard(), loadMerchantCarousel()])
    } else {
      merchantRequests.value = []
      merchantRequestsError.value = ''
    }
  }
)

watch(
  () => isAdmin.value,
  (flag) => {
    adminActivePanel.value = adminPanels[0].key
    if (!flag) {
      adminCommandFeedback.value = ''
      merchantRequests.value = []
      merchantRequestsError.value = ''
    } else {
      loadMerchantRequests()
    }
  }
)

watch(
  () => showWorkbench.value,
  (canAccess) => {
    if (!canAccess && activeTab.value === 'order') {
      activeTab.value = 'home'
    }
  }
)

onMounted(async () => {
  try {
    await loadSharedResources()
  } catch (error) {
    console.error('初始化数据失败', error)
  }
  if (isAdmin.value) {
    await Promise.allSettled([loadAdminResources(), loadMerchantRequests()])
  }
  if (isMerchant.value) {
    await loadMerchantCarousel()
  }
})
</script>

<style scoped>
.mini-app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: linear-gradient(180deg, #0f172a 0%, #0b1120 45%, #111827 100%);
  color: #e2e8f0;
}

.status-bar {
  padding: 16px 20px;
  font-size: 0.9rem;
  letter-spacing: 0.08em;
  color: rgba(248, 250, 252, 0.7);
  text-transform: uppercase;
}

.content {
  flex: 1;
  overflow-y: auto;
  padding: 12px 16px 80px;
}

.panel {
  background: rgba(15, 23, 42, 0.75);
  border-radius: 20px;
  padding: 20px;
  box-shadow: 0 24px 48px rgba(15, 23, 42, 0.45);
  backdrop-filter: blur(18px);
}

.panel.home-panel {
  padding: 0;
  background: transparent;
  box-shadow: none;
}

.store-gate {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
}

.store-gate h2 {
  margin: 4px 0;
}

.store-gate small {
  color: rgba(148, 163, 184, 0.85);
}

.store-gate.empty {
  border-style: dashed;
}

.store-gate-empty {
  border-radius: 18px;
  border: 1px dashed rgba(148, 163, 184, 0.4);
  padding: 24px;
  text-align: center;
  color: rgba(148, 163, 184, 0.9);
  display: grid;
  gap: 12px;
}

.store-gate-empty.explore-empty {
  margin-top: 16px;
}

.merchant-home {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.admin-explore-switch {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
  background: rgba(15, 23, 42, 0.65);
  padding: 6px;
  border-radius: 14px;
  border: 1px solid rgba(148, 163, 184, 0.25);
}

.admin-explore-switch button {
  flex: 1;
  border: none;
  background: transparent;
  color: rgba(148, 163, 184, 0.85);
  padding: 10px 12px;
  border-radius: 12px;
  font-weight: 600;
}

.admin-explore-switch button.active {
  background: rgba(59, 130, 246, 0.2);
  color: #e2e8f0;
  box-shadow: inset 0 0 12px rgba(15, 23, 42, 0.3);
}

.admin-request-board {
  border-radius: 20px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.75);
  padding: 20px;
  display: grid;
  gap: 20px;
}

.request-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 12px;
}

.request-summary-card {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.5);
  padding: 12px;
}

.request-summary-card strong {
  font-size: 1.6rem;
  display: block;
}

.request-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
}

.request-list li {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 16px;
  background: rgba(15, 23, 42, 0.5);
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.request-meta {
  margin: 4px 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.9rem;
}

.request-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.history-list {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  padding: 16px;
  background: rgba(15, 23, 42, 0.5);
}

.history-list ul {
  list-style: none;
  margin: 12px 0 0;
  padding: 0;
  display: grid;
  gap: 10px;
}

.history-list li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  padding-bottom: 10px;
  border-bottom: 1px dashed rgba(148, 163, 184, 0.2);
}

.history-list li:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.merchant-carousel-card,
.merchant-recommend-card,
.merchant-home-actions {
  border-radius: 20px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.7);
  padding: 20px;
  display: grid;
  gap: 16px;
}

.carousel-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

.carousel-card {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 12px;
  background: rgba(15, 23, 42, 0.6);
  display: grid;
  gap: 8px;
}

.carousel-thumb {
  border-radius: 12px;
  height: 110px;
  background-size: cover;
  background-position: center;
}

.recommend-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

.merchant-home-actions .action-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

.product-library-panel {
  border-radius: 20px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.75);
  padding: 20px;
  display: grid;
  gap: 20px;
}

.product-form .form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}

.product-form label {
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-size: 0.9rem;
  color: rgba(226, 232, 240, 0.9);
}

.product-form label span {
  font-weight: 500;
}

.product-form .toggle-row {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 8px 12px;
  border-radius: 14px;
  border: 1px dashed rgba(148, 163, 184, 0.35);
  background: rgba(15, 23, 42, 0.45);
  color: rgba(226, 232, 240, 0.92);
}

.product-form .toggle-row input[type='checkbox'] {
  width: 18px;
  height: 18px;
}

.product-form .full-width {
  grid-column: 1 / -1;
}

.product-form textarea {
  grid-column: 1 / -1;
  resize: vertical;
}

.product-form .option-section {
  grid-column: 1 / -1;
  border: 1px solid rgba(148, 163, 184, 0.25);
  border-radius: 18px;
  padding: 16px;
  background: rgba(15, 23, 42, 0.4);
}
.product-form .option-section header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 12px;
}
.product-form .option-section header h4 {
  font-size: 1rem;
  margin: 0;
  color: #f8fafc;
}
.product-form .option-section header small {
  color: rgba(148, 163, 184, 0.95);
}
.product-form .option-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.product-form .option-list li {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: center;
  padding: 12px 16px;
  border-radius: 14px;
  background: rgba(15, 23, 42, 0.35);
}
.product-form .option-info strong {
  display: block;
  color: #f8fafc;
}
.product-form .option-info small {
  color: rgba(148, 163, 184, 0.95);
  font-size: 0.88rem;
}
.product-form .option-controls {
  display: flex;
  gap: 16px;
  align-items: center;
}
.product-form .option-controls label {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 0.9rem;
  color: rgba(226, 232, 240, 0.92);
}

.image-preview {
  margin-top: 8px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.image-preview img {
  width: 72px;
  height: 72px;
  object-fit: cover;
  border-radius: 12px;
  border: 1px solid rgba(148, 163, 184, 0.3);
}

.form-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.library-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 12px;
}

.summary-card {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 16px;
  background: rgba(15, 23, 42, 0.6);
  display: grid;
  gap: 8px;
}

.summary-head {
  display: flex;
  align-items: center;
  gap: 12px;
}

.summary-icon {
  width: 42px;
  height: 42px;
  border-radius: 14px;
  background: rgba(59, 130, 246, 0.15);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
}

.summary-label {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
}

.summary-card strong {
  font-size: 1.5rem;
}

.summary-card p {
  margin: 0;
  color: rgba(226, 232, 240, 0.85);
}

.library-tip {
  grid-column: 1 / -1;
  margin: 4px 0 0;
  color: rgba(148, 163, 184, 0.8);
  font-size: 0.9rem;
}

.merchant-workbench {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.merchant-status-card,
.merchant-menu-card,
.merchant-orders {
  border-radius: 20px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.7);
  padding: 20px;
  display: grid;
  gap: 16px;
}

.status-select {
  display: grid;
  gap: 6px;
  min-width: 140px;
}

.status-note textarea {
  width: 100%;
  padding: 12px;
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.5);
  color: #e2e8f0;
}

.status-metrics {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;
}

.status-metrics li {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 12px;
  background: rgba(15, 23, 42, 0.5);
}

.menu-controls {
  display: grid;
  gap: 8px;
}

.bulk-actions {
  display: inline-flex;
  gap: 8px;
  flex-wrap: wrap;
}

.menu-toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
}

.menu-search {
  flex: 1;
  min-width: 160px;
  padding: 10px 12px;
  border-radius: 12px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: rgba(15, 23, 42, 0.6);
  color: #e2e8f0;
}

.menu-toggle {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.95);
}

.menu-toggle input {
  width: 16px;
  height: 16px;
}

.menu-tip {
  margin: 0;
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.9);
}

.menu-accordion {
  display: grid;
  gap: 12px;
}

.menu-panel {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.55);
  overflow: hidden;
}

.menu-panel header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  cursor: pointer;
}

.menu-panel header small {
  color: rgba(148, 163, 184, 0.85);
}

.menu-panel-body {
  padding: 12px 16px 16px;
  border-top: 1px solid rgba(148, 163, 184, 0.15);
}

.menu-panel-body.scrollable {
  max-height: 420px;
  overflow-y: auto;
  padding-right: 8px;
}

.accordion-enter-active,
.accordion-leave-active {
  transition: height 0.2s ease, opacity 0.2s ease;
}

.accordion-enter-from,
.accordion-leave-to {
  height: 0;
  opacity: 0;
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 12px;
}

.menu-grid.compact {
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
}

.menu-card {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 16px;
  background: rgba(15, 23, 42, 0.6);
  display: grid;
  gap: 10px;
}

.menu-card.compact {
  gap: 6px;
}

.menu-card.selectable {
  border: 1px dashed rgba(148, 163, 184, 0.4);
  transition: border-color 0.2s ease;
}

.menu-card.selectable.selected {
  border-color: rgba(59, 130, 246, 0.9);
  box-shadow: 0 0 0 1px rgba(59, 130, 246, 0.3);
}

.menu-card.compact .mini-row {
  display: flex;
  justify-content: space-between;
  gap: 8px;
  align-items: center;
}

.menu-card.compact .mini-row.meta {
  font-size: 0.85rem;
}

.menu-card.compact select,
.menu-card.compact input {
  width: 100%;
  padding: 6px 8px;
  border-radius: 10px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: rgba(15, 23, 42, 0.5);
  color: #e2e8f0;
}

.menu-slot {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
}

.menu-slot select {
  margin-left: 8px;
  padding: 6px 10px;
  border-radius: 12px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: rgba(15, 23, 42, 0.6);
  color: #e2e8f0;
}

.menu-progress .bar {
  height: 6px;
  border-radius: 999px;
  background: rgba(51, 65, 85, 0.8);
  overflow: hidden;
  margin-bottom: 6px;
}

.menu-progress .bar span {
  display: block;
  height: 100%;
  background: linear-gradient(120deg, #22d3ee, #38bdf8);
}

.menu-progress input {
  width: 100%;
  padding: 10px;
  border-radius: 12px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: rgba(15, 23, 42, 0.6);
  color: #e2e8f0;
}

.menu-meta {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 4px;
  color: rgba(148, 163, 184, 0.85);
}

.menu-actions {
  display: grid;
  gap: 10px;
}

.menu-scroll-hint {
  display: block;
  margin-top: 6px;
  text-align: right;
  font-size: 0.8rem;
  color: rgba(148, 163, 184, 0.8);
}

.ghost.icon-only {
  padding: 6px 12px;
}

.ghost.mini {
  padding: 6px 10px;
  border-radius: 10px;
}

.menu-status {
  border-radius: 999px;
  padding: 4px 10px;
  font-size: 0.75rem;
  border: 1px solid rgba(148, 163, 184, 0.35);
}

.menu-status.paused {
  border-color: rgba(248, 113, 113, 0.5);
  color: #fecaca;
}

.menu-qty {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
}

.merchant-pipeline {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;
}

.merchant-pipeline article {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 12px;
  background: rgba(15, 23, 42, 0.55);
}

.profile-actions.merchant-profile-actions {
  margin-top: 16px;
  border-color: rgba(59, 130, 246, 0.25);
  background: rgba(15, 23, 42, 0.65);
}

.merchant-profile-overview {
  display: grid;
  gap: 12px;
}

.status-overview {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.3);
  padding: 12px;
  background: rgba(15, 23, 42, 0.55);
}

.status-pill {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 999px;
  padding: 4px 12px;
  font-size: 0.8rem;
  border: 1px solid rgba(148, 163, 184, 0.4);
  color: rgba(226, 232, 240, 0.9);
}

.status-pill.success {
  border-color: rgba(34, 197, 94, 0.5);
  color: #4ade80;
}

.status-pill.pending {
  border-color: rgba(251, 191, 36, 0.6);
  color: #facc15;
}

.status-pill.disabled {
  border-color: rgba(148, 163, 184, 0.4);
  color: rgba(148, 163, 184, 0.8);
}

.panel.explore-panel {
  padding: 0;
  background: transparent;
  box-shadow: none;
}

.admin-workbench {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.admin-hero {
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.admin-meta {
  display: grid;
  gap: 4px;
  text-align: right;
}

.section-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  justify-content: flex-end;
}

.section-actions .primary,
.section-actions .ghost {
  flex: none;
}

.admin-callout {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.55);
  padding: 16px;
  display: grid;
  gap: 8px;
}

.admin-callout ul {
  margin: 0;
  padding-left: 18px;
  color: rgba(148, 163, 184, 0.85);
  display: grid;
  gap: 4px;
}

.admin-summary-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;
  margin: 18px 0;
}

.admin-summary-grid article {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.5);
  padding: 14px;
  display: grid;
  gap: 6px;
}

.request-preview {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(2, 6, 23, 0.55);
  padding: 16px;
  display: grid;
  gap: 12px;
}

.request-preview header {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  align-items: center;
  flex-wrap: wrap;
}

.request-preview ul {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
}

.request-preview li {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  border-bottom: 1px dashed rgba(148, 163, 184, 0.25);
  padding-bottom: 10px;
}

.request-preview li:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.request-preview .request-meta {
  text-align: right;
  color: rgba(148, 163, 184, 0.85);
  display: grid;
  gap: 2px;
}

.admin-meta strong {
  font-size: 1.2rem;
}

.admin-meta button {
  justify-self: end;
}

.eyebrow {
  margin: 0;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  font-size: 0.8rem;
  color: rgba(148, 163, 184, 0.85);
}

.admin-subtabs {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 8px;
}

.admin-subtabs button {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.4);
  padding: 12px;
  display: flex;
  align-items: center;
  gap: 10px;
  color: #e2e8f0;
}

.admin-subtabs button strong {
  display: block;
  font-size: 0.95rem;
}

.admin-subtabs button small {
  color: rgba(148, 163, 184, 0.8);
}

.admin-subtabs button.active {
  border-color: rgba(56, 189, 248, 0.65);
  background: rgba(56, 189, 248, 0.15);
}

.admin-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.admin-kpi-grid {
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
}

.dashboard-secondary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
}

.timeline-card,
.insight-card {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.6);
  padding: 16px;
  display: grid;
  gap: 12px;
}

.pipeline {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 12px;
}

.pipeline-head {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}

.pipeline-bar {
  height: 6px;
  border-radius: 999px;
  background: rgba(148, 163, 184, 0.2);
  overflow: hidden;
}

.pipeline-bar span {
  display: block;
  height: 100%;
  border-radius: 999px;
  background: linear-gradient(120deg, #38bdf8, #22d3ee);
}

.insight-title {
  margin: 0;
  font-size: 1.2rem;
}

.insight-desc {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.section-header div > h2 {
  margin: 0;
}

.section-desc {
  margin: 4px 0 0;
  color: rgba(148, 163, 184, 0.85);
}

.pipeline-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

.order-stage-card {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.55);
  padding: 14px;
  display: grid;
  gap: 8px;
}

.order-hints {
  border-radius: 16px;
  border: 1px dashed rgba(148, 163, 184, 0.4);
  padding: 12px 16px;
  color: rgba(148, 163, 184, 0.85);
  background: rgba(15, 23, 42, 0.35);
}

.campaign-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 12px;
}

.campaign-card {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.55);
  padding: 16px;
  display: grid;
  gap: 10px;
}

.insight-matrix {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

.insight-card.compact button {
  justify-self: flex-start;
}

.settings-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
}

.settings-list li {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.5);
  padding: 16px;
  display: flex;
  justify-content: space-between;
  gap: 12px;
  align-items: center;
}

.admin-feedback {
  margin: 0;
  text-align: center;
  color: rgba(125, 211, 252, 0.9);
}

.panel-header {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-bottom: 16px;
}

.heading {
  font-size: 1.6rem;
  margin-bottom: 4px;
}

.subheading {
  color: rgba(148, 163, 184, 0.9);
  font-size: 0.95rem;
  margin-bottom: 18px;
}

.dashboard-grid {
  display: grid;
  gap: 12px;
  margin-bottom: 24px;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
}

.dashboard-card {
  padding: 18px;
  border-radius: 16px;
  background: rgba(30, 41, 59, 0.8);
  border: 1px solid rgba(148, 163, 184, 0.18);
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.dashboard-card h3 {
  margin: 0;
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.9);
}

.dashboard-card span {
  font-size: 1.4rem;
  font-weight: 700;
}

.dashboard-card.highlight {
  grid-column: span 2;
  background: linear-gradient(145deg, rgba(14, 165, 233, 0.2), rgba(99, 102, 241, 0.25));
}

label {
  font-size: 0.9rem;
  color: rgba(226, 232, 240, 0.85);
}

input,
select,
textarea {
  width: 100%;
  padding: 14px 16px;
  border-radius: 14px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
  color: #f8fafc;
}

textarea {
  resize: vertical;
}

input:focus,
select:focus,
textarea:focus {
  outline: none;
  border-color: rgba(96, 165, 250, 0.75);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
}

button {
  cursor: pointer;
}

button.primary {
  flex: none;
  padding: 14px 24px;
  border-radius: 999px;
  border: none;
  font-size: 1rem;
  font-weight: 600;
  color: #020617;
  background: linear-gradient(135deg, #38bdf8, #22d3ee 55%, #60a5fa);
  box-shadow: 0 18px 32px rgba(14, 165, 233, 0.35);
}

button.ghost {
  padding: 14px 24px;
  border-radius: 999px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: transparent;
  color: #e2e8f0;
}

button.danger {
  padding: 14px 24px;
  border-radius: 999px;
  border: none;
  background: rgba(248, 113, 113, 0.2);
  color: #fecaca;
}

.error {
  color: #f87171;
  font-size: 0.85rem;
}

.order-board {
  display: grid;
  gap: 16px;
}

.order-board-limited {
  max-height: min(70vh, calc(6 * 190px));
  overflow-y: auto;
  padding-right: 6px;
}

.order-board-limited::-webkit-scrollbar {
  width: 4px;
}

.order-board-limited::-webkit-scrollbar-thumb {
  background: rgba(148, 163, 184, 0.35);
  border-radius: 999px;
}

.order-scroll-hint {
  margin: 8px 0 0;
  text-align: right;
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.85);
}

.order-card {
  padding: 18px;
  border-radius: 18px;
  background: rgba(30, 41, 59, 0.7);
  border: 1px solid rgba(148, 163, 184, 0.2);
  display: grid;
  gap: 12px;
}

.order-card header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-card ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 6px;
  color: rgba(226, 232, 240, 0.85);
  font-size: 0.95rem;
}

.order-card footer {
  display: flex;
  gap: 10px;
}

.status {
  padding: 6px 12px;
  border-radius: 999px;
  font-size: 0.8rem;
  color: #0f172a;
  background: rgba(96, 165, 250, 0.85);
}

.status.preparing {
  background: rgba(251, 191, 36, 0.75);
}

.status.ready {
  background: rgba(34, 211, 238, 0.75);
}

.status.completed {
  background: rgba(134, 239, 172, 0.75);
}

.empty-state {
  text-align: center;
  padding: 48px 0;
  color: rgba(226, 232, 240, 0.75);
}

.store-picker-page {
  display: grid;
  gap: 16px;
}

.store-page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}

.store-page-header > div {
  flex: 1;
}

.store-page-header .back-link {
  flex: none;
}

.store-title {
  margin: 0;
  font-size: 1.4rem;
  font-weight: 700;
  color: #f8fafc;
}

.store-note {
  color: rgba(148, 163, 184, 0.85);
}

.store-intro {
  margin: 0;
  color: rgba(226, 232, 240, 0.75);
}

.store-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 12px;
}

.store-list li button {
  width: 100%;
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.65);
  padding: 14px 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #e2e8f0;
  gap: 12px;
}

.store-list li button.active {
  border-color: rgba(59, 130, 246, 0.7);
  background: rgba(59, 130, 246, 0.15);
}

.store-list strong {
  font-size: 1rem;
}

.store-list span {
  display: block;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.9rem;
}

.distance {
  font-weight: 600;
  color: rgba(129, 140, 248, 0.95);
}

.store-empty {
  text-align: center;
  padding: 24px 12px;
  border-radius: 16px;
  background: rgba(15, 23, 42, 0.45);
  color: rgba(148, 163, 184, 0.9);
}

.store-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}

.store-actions .ghost,
.store-actions .primary {
  flex: 1;
}

.store-denied {
  color: rgba(248, 113, 113, 0.85);
  font-size: 0.85rem;
}

.checkout-panel {
  display: grid;
  gap: 16px;
}

.section-label {
  margin: 0;
  font-size: 0.8rem;
  letter-spacing: 0.08em;
  color: rgba(148, 163, 184, 0.85);
}

.checkout-store {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.checkout-store h2 {
  margin: 4px 0 2px;
}

.checkout-store small {
  color: rgba(148, 163, 184, 0.85);
}

.checkout-contact {
  display: flex;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px;
  border-radius: 16px;
  background: rgba(15, 23, 42, 0.65);
  border: 1px solid rgba(148, 163, 184, 0.2);
}

.checkout-contact.warning {
  flex-wrap: wrap;
  border-color: rgba(248, 113, 113, 0.35);
  background: rgba(248, 113, 113, 0.08);
}

.checkout-contact p {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.85rem;
}

.checkout-contact strong {
  display: block;
  font-size: 1.05rem;
}

.checkout-contact button {
  flex: none;
}

.checkout-pickup {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 16px;
  display: grid;
  gap: 12px;
  background: rgba(15, 23, 42, 0.55);
}

.checkout-pickup header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}

.checkout-pickup header p {
  margin: 0;
}

.checkout-pickup header small {
  color: rgba(148, 163, 184, 0.85);
}

.pickup-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;
}

.pickup-options button {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 12px;
  text-align: left;
  background: rgba(15, 23, 42, 0.45);
  color: #e2e8f0;
  display: grid;
  gap: 4px;
}

.pickup-options button.active {
  border-color: rgba(56, 189, 248, 0.65);
  background: rgba(56, 189, 248, 0.18);
  color: #f8fafc;
}

.pickup-options button strong {
  font-size: 1rem;
}

.pickup-options button span {
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.85);
}

.checkout-products {
  border-radius: 18px;
  padding: 16px;
  background: rgba(15, 23, 42, 0.5);
  border: 1px solid rgba(148, 163, 184, 0.25);
  display: grid;
  gap: 12px;
}

.checkout-products header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.checkout-products header p {
  margin: 0;
  font-weight: 600;
}

.checkout-products header small {
  color: rgba(148, 163, 184, 0.85);
}

.checkout-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
  max-height: 360px;
  overflow-y: auto;
  padding-right: 4px;
}

.checkout-list li {
  display: grid;
  grid-template-columns: 72px 1fr auto;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(148, 163, 184, 0.25);
}

.checkout-list li:last-child {
  border-bottom: none;
}

.checkout-list .thumb {
  border-radius: 16px;
  min-height: 72px;
  background-size: cover;
  background-position: center;
  position: relative;
}

.checkout-list .mini-tag {
  top: 8px;
  left: 8px;
}

.checkout-list .item-info {
  display: grid;
  gap: 4px;
}

.checkout-list .item-info h3 {
  margin: 0;
  font-size: 1rem;
}

.checkout-list .item-info p {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.85rem;
}

.checkout-list .item-info span {
  font-weight: 600;
}

.checkout-list .item-qty {
  font-weight: 700;
  align-self: center;
  color: rgba(226, 232, 240, 0.95);
}

.checkout-summary {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-radius: 999px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
}

.checkout-summary strong {
  font-size: 1.2rem;
}

.checkout-remark {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-radius: 16px;
  border: 1px dashed rgba(148, 163, 184, 0.4);
  background: rgba(15, 23, 42, 0.35);
}

.checkout-remark p {
  margin: 0;
  font-weight: 600;
}

.checkout-remark small {
  color: rgba(148, 163, 184, 0.85);
}

.remark-editor {
  width: 100%;
  min-height: 90px;
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: rgba(15, 23, 42, 0.55);
  color: #f8fafc;
  padding: 14px;
  resize: vertical;
}

.checkout-submit {
  width: 100%;
  font-size: 1.05rem;
}

.explore .overview-grid {
  margin-bottom: 32px;
}

.overview-grid {
  display: grid;
  gap: 16px;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
}

.overview-card {
  padding: 16px;
  border-radius: 18px;
  background: rgba(30, 41, 59, 0.75);
  border: 1px solid rgba(148, 163, 184, 0.18);
}

.overview-card h3 {
  margin: 0;
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.9);
}

.overview-card span {
  display: block;
  margin-top: 8px;
  font-size: 1.4rem;
  font-weight: 700;
}

.overview-card.highlight {
  grid-column: span 2;
  background: linear-gradient(145deg, rgba(59, 130, 246, 0.2), rgba(129, 140, 248, 0.25));
}

.auth-card {
  background: rgba(15, 23, 42, 0.65);
  border-radius: 20px;
  padding: 20px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  display: grid;
  gap: 18px;
}

.tabs {
  display: inline-flex;
  background: rgba(30, 41, 59, 0.8);
  border-radius: 999px;
  padding: 4px;
}

.tabs button {
  padding: 10px 22px;
  border-radius: 999px;
  border: none;
  background: transparent;
  color: rgba(226, 232, 240, 0.75);
}

.tabs button.active {
  background: linear-gradient(135deg, rgba(14, 165, 233, 0.35), rgba(79, 70, 229, 0.4));
  color: #f8fafc;
}

.role-switcher {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.role-switcher button {
  flex: 1 1 30%;
  padding: 10px 12px;
  border-radius: 12px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: transparent;
  color: rgba(226, 232, 240, 0.75);
  font-size: 0.9rem;
}

.role-switcher button.active {
  background: rgba(59, 130, 246, 0.25);
  border-color: rgba(59, 130, 246, 0.55);
  color: #f8fafc;
}

.form-hint {
  margin: 4px 0 0;
  font-size: 0.85rem;
  color: rgba(248, 250, 252, 0.7);
}

.feedback {
  margin: 0;
  color: rgba(125, 211, 252, 0.9);
}

.current-user {
  display: grid;
  gap: 10px;
  padding: 16px;
  border-radius: 14px;
  background: rgba(30, 41, 59, 0.6);
}

.detail-card {
  margin-top: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
}

.tabbar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  background: rgba(15, 23, 42, 0.85);
  backdrop-filter: blur(16px);
  border-top: 1px solid rgba(148, 163, 184, 0.15);
  height: 64px;
}

.tabbar button {
  border: none;
  background: transparent;
  color: rgba(148, 163, 184, 0.9);
  padding: 10px 0;
  display: grid;
  place-items: center;
  gap: 4px;
  font-size: 0.8rem;
}

.tabbar.compact {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.tabbar.compact {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.tabbar button.active {
  color: #f8fafc;
}

.icon {
  font-size: 1.2rem;
}

@media (min-width: 768px) {
  .content {
    max-width: 960px;
    margin: 0 auto;
  }

  .dashboard-card.highlight,
  .overview-card.highlight {
    grid-column: span 1;
  }

  .tabbar {
    position: static;
    margin-top: 24px;
    border-radius: 20px;
    overflow: hidden;
  }
}

.profile-hero {
  position: relative;
  border-radius: 22px;
  background: #0f172a;
  border: 1px solid rgba(59, 130, 246, 0.3);
  overflow: hidden;
  min-height: 170px;
  padding: 24px;
  box-shadow: 0 20px 40px rgba(15, 23, 42, 0.5);
}

.banner-bg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.banner-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(15, 23, 42, 0.9), rgba(15, 23, 42, 0.2));
}

.banner-action {
  position: absolute;
  top: 12px;
  right: 12px;
  z-index: 2;
  color: #f8fafc;
}

.banner-content {
  position: relative;
  z-index: 2;
  color: #f8fafc;
  max-width: 65%;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.banner-greeting {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
}

.banner-role {
  color: rgba(248, 250, 252, 0.85);
  font-size: 0.95rem;
}

.hero-avatar {
  position: absolute;
  right: 24px;
  bottom: 24px;
  width: 88px;
  height: 88px;
  border-radius: 28px;
  background: rgba(15, 23, 42, 0.85);
  border: 4px solid rgba(248, 250, 252, 0.8);
  display: grid;
  place-items: center;
  color: #f8fafc;
  font-weight: 700;
  font-size: 1.8rem;
  z-index: 3;
  box-shadow: 0 12px 30px rgba(15, 23, 42, 0.4);
}

.hero-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 24px;
}

.profile-highlights {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 12px;
  margin-top: 48px;
}

.profile-highlights article {
  border-radius: 18px;
  padding: 16px;
  background: rgba(15, 23, 42, 0.65);
  border: 1px solid rgba(148, 163, 184, 0.2);
  box-shadow: inset 0 0 0 1px rgba(15, 23, 42, 0.2);
  display: grid;
  gap: 6px;
}

.profile-highlights strong {
  font-size: 1.4rem;
  font-weight: 700;
  margin: 0;
}

.profile-highlights span {
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.85rem;
}

.card-label {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
  font-size: 0.85rem;
}

.profile-actions {
  margin-top: 20px;
  border-radius: 18px;
  padding: 4px;
  background: rgba(15, 23, 42, 0.55);
  border: 1px solid rgba(148, 163, 184, 0.2);
  display: grid;
  gap: 6px;
}

.profile-actions button {
  width: 100%;
  border: none;
  background: transparent;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 14px;
  border-radius: 14px;
  color: #f8fafc;
  transition: background 0.2s ease, transform 0.1s ease;
}

.profile-actions button:hover,
.profile-actions button:focus-visible {
  background: rgba(59, 130, 246, 0.15);
}

.profile-actions button:active {
  transform: scale(0.98);
}

.action-icon {
  font-size: 1.2rem;
  width: 36px;
}

.action-info {
  flex: 1;
}

.action-info p {
  margin: 0;
  font-weight: 600;
}

.action-info small {
  color: rgba(148, 163, 184, 0.85);
}

.action-arrow {
  color: rgba(148, 163, 184, 0.85);
  font-size: 1.2rem;
}

.profile-auth .primary,
.gate-cta {
  border-radius: 999px;
  background: linear-gradient(135deg, #38bdf8, #22d3ee);
  transition: transform 0.1s ease, box-shadow 0.2s ease;
}

.profile-auth .primary:active,
.gate-cta:active {
  transform: scale(0.98);
  box-shadow: 0 6px 20px rgba(34, 211, 238, 0.35);
}

.profile-auth.compact {
  text-align: center;
  gap: 8px;
}

.cta-hint {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.9rem;
}

.auth-full .back-link {
  align-self: flex-start;
  margin-bottom: 12px;
}

.settings-panel {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.settings-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}

.settings-body {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.icon-only {
  min-width: 48px;
}

.settings-card {
  padding: 18px;
  border-radius: 18px;
  background: rgba(30, 41, 59, 0.85);
  border: 1px solid rgba(148, 163, 184, 0.25);
  text-align: center;
}

.avatar-shell.large {
  width: 96px;
  height: 96px;
  font-size: 2.3rem;
  margin: 0 auto;
  position: relative;
}

.avatar-shell.large img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 50%;
}

.avatar-edit {
  position: absolute;
  bottom: -6px;
  right: -6px;
  border-radius: 18px;
  background: #38bdf8;
  color: #0f172a;
  padding: 4px 12px;
  font-size: 0.8rem;
}

.avatar-edit:disabled {
  opacity: 0.7;
}

.avatar-preview p {
  margin: 16px 0 4px;
  font-weight: 600;
}

.membership-code {
  color: rgba(148, 163, 184, 0.8);
  letter-spacing: 0.2em;
}

.profile-form {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.form-row.required label::after {
  content: '*';
  color: #f87171;
  margin-left: 4px;
}

.sticky-actions {
  margin-top: 8px;
}

.upload-hint {
  display: block;
  margin-top: 8px;
  color: rgba(148, 163, 184, 0.85);
}

.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

</style>
