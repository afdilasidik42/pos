# PowerShell script to generate self-contained index.html with embedded Base64 images and Moka POS styling

$b64Json = Get-Content 'd:\job\pos\assets_base64.json' -Raw

$template = @'
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Loko Coffee — POS, Accounting & Web Order (Professional Prototype)</title>
  <style>
    /* ==========================================================================
       DESIGN TOKENS (MOKA POS ENTERPRISE THEME)
       ========================================================================== */
    :root {
      /* Primary Brand: Sober Enterprise Green */
      --primary: #154734;
      --primary-dark: #0D2E21;
      --primary-hover: #1E5C44;
      --primary-light: #EBF4F0;
      --primary-border: #BCD5CA;

      /* Secondary & Accents: Used sparingly */
      --accent-warm: #C86D27;
      --accent-warm-light: #FEF7ED;

      /* Neutral Surfaces & Backgrounds */
      --canvas: #F4F5F7;
      --surface: #FFFFFF;
      --surface-secondary: #FAFAFA;
      --surface-hover: #F8F9FA;

      /* Borders */
      --border-color: #E2E5E8;
      --border-subtle: #EEF0F2;
      --border-focus: #154734;

      /* Typography */
      --text-main: #1F2937;
      --text-secondary: #4B5563;
      --text-muted: #8C96A3;
      --text-inverse: #FFFFFF;

      /* Status Colors */
      --success: #059669;
      --success-bg: #ECFDF5;
      --success-border: #A7F3D0;

      --warning: #D97706;
      --warning-bg: #FFFBEB;
      --warning-border: #FDE68A;

      --danger: #DC2626;
      --danger-bg: #FEF2F2;
      --danger-border: #FECACA;

      --info: #2563EB;
      --info-bg: #EFF6FF;
      --info-border: #BFDBFE;

      /* Radii (Clean, sharp Moka lines) */
      --radius-sm: 4px;
      --radius-md: 6px;
      --radius-lg: 10px;
      --radius-pill: 9999px;

      /* Shadows: Minimal & Crisp */
      --shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);
      --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.03);
      --shadow-md: 0 4px 8px -1px rgba(0, 0, 0, 0.07), 0 2px 4px -1px rgba(0, 0, 0, 0.04);
      --shadow-lg: 0 12px 24px -4px rgba(0, 0, 0, 0.1), 0 4px 8px -2px rgba(0, 0, 0, 0.04);
      --shadow-float: 0 20px 35px -5px rgba(15, 35, 25, 0.25);

      --font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      -webkit-font-smoothing: antialiased;
    }

    body {
      font-family: var(--font-family);
      background-color: #0F1713;
      color: var(--text-main);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      overflow-x: hidden;
    }

    button, input, select, textarea {
      font-family: inherit;
    }

    button {
      cursor: pointer;
      border: none;
      background: none;
      outline: none;
    }

    /* Tabular numeric alignment for finance & prices */
    .tabular-nums {
      font-variant-numeric: tabular-nums;
    }

    /* Inline SVG helper */
    .ui-icon {
      display: inline-block;
      width: 16px;
      height: 16px;
      vertical-align: middle;
      stroke-width: 2;
      stroke: currentColor;
      fill: none;
      stroke-linecap: round;
      stroke-linejoin: round;
    }
    .ui-icon-lg {
      width: 20px;
      height: 20px;
    }

    /* ==========================================================================
       TOP PRESENTER TOOLBAR (CONTROL BAR)
       ========================================================================== */
    .presenter-bar {
      background: #0B2117;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      padding: 10px 24px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      color: #FFFFFF;
      position: sticky;
      top: 0;
      z-index: 1000;
      gap: 16px;
      flex-wrap: wrap;
    }

    .brand-group {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .brand-badge {
      display: flex;
      align-items: center;
      gap: 8px;
      background: #154734;
      border: 1px solid rgba(255, 255, 255, 0.2);
      padding: 5px 12px;
      border-radius: var(--radius-sm);
      font-size: 13px;
      font-weight: 700;
      letter-spacing: 0.5px;
      color: #FFFFFF;
    }

    .brand-title {
      font-size: 14px;
      font-weight: 500;
      color: #D1D5DB;
    }
    .brand-title strong {
      color: #FFFFFF;
      font-weight: 700;
    }

    .device-switcher {
      display: flex;
      background: rgba(255, 255, 255, 0.07);
      border-radius: var(--radius-md);
      padding: 3px;
      gap: 2px;
    }

    .switcher-btn {
      padding: 6px 14px;
      border-radius: var(--radius-sm);
      font-size: 13px;
      font-weight: 600;
      color: #9CA3AF;
      display: flex;
      align-items: center;
      gap: 8px;
      transition: all 0.15s ease;
    }
    .switcher-btn:hover {
      color: #FFFFFF;
      background: rgba(255, 255, 255, 0.05);
    }
    .switcher-btn.active {
      background: #154734;
      color: #FFFFFF;
      box-shadow: var(--shadow-sm);
    }

    .toolbar-actions {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .tool-pill {
      background: rgba(255, 255, 255, 0.08);
      border: 1px solid rgba(255, 255, 255, 0.14);
      color: #E5E7EB;
      padding: 6px 12px;
      border-radius: var(--radius-sm);
      font-size: 12px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 6px;
      transition: background 0.15s;
    }
    .tool-pill:hover {
      background: rgba(255, 255, 255, 0.15);
      color: #FFFFFF;
    }

    .tax-toggle-btn {
      background: #183C2D;
      color: #6EE7B7;
      border-color: rgba(110, 231, 183, 0.25);
    }

    .btn-guide {
      background: #C86D27;
      color: #FFFFFF;
      border-color: #C86D27;
    }
    .btn-guide:hover {
      background: #B35F1F;
    }

    /* ==========================================================================
       WORKSPACE & DEVICE SIMULATOR FRAMES
       ========================================================================== */
    .app-viewport-container {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px 16px;
      background: #111B16;
      overflow: auto;
    }

    /* Tablet Landscape Frame (Loko POS) */
    .frame-tablet {
      width: 100%;
      max-width: 1260px;
      height: 820px;
      background: var(--canvas);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-float), 0 0 0 10px #1E2822, 0 0 0 12px rgba(255, 255, 255, 0.08);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      position: relative;
    }

    /* Mobile Frame (Loko Order & WhatsApp) */
    .frame-mobile {
      width: 410px;
      height: 840px;
      background: #000000;
      border-radius: 46px;
      box-shadow: var(--shadow-float), 0 0 0 10px #1C2621, 0 0 0 12px rgba(255, 255, 255, 0.1);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      position: relative;
      border: 4px solid #28362F;
    }

    .phone-notch {
      position: absolute;
      top: 10px;
      left: 50%;
      transform: translateX(-50%);
      width: 120px;
      height: 26px;
      background: #000000;
      border-radius: 20px;
      z-index: 999;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .phone-camera-lens {
      width: 10px;
      height: 10px;
      border-radius: 50%;
      background: #151515;
      border: 1px solid #333333;
    }
    .mobile-status-bar {
      height: 42px;
      padding: 8px 24px 0 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 13px;
      font-weight: 600;
      z-index: 998;
      background: inherit;
    }

    /* View Switcher Panels */
    .view-panel {
      display: none;
      width: 100%;
      height: 100%;
      flex-direction: column;
    }
    .view-panel.active {
      display: flex;
    }

    /* ==========================================================================
       LOKO POS — MOKA STYLE PROFESSIONAL INTERFACE
       ========================================================================== */
    .pos-header {
      background: var(--primary);
      color: #FFFFFF;
      height: 56px;
      padding: 0 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      border-bottom: 1px solid var(--primary-dark);
      user-select: none;
    }

    .pos-nav-tabs {
      display: flex;
      gap: 4px;
      height: 100%;
      align-items: flex-end;
    }

    .pos-tab-btn {
      padding: 10px 20px;
      font-size: 14px;
      font-weight: 600;
      color: #B2D1C5;
      display: flex;
      align-items: center;
      gap: 8px;
      border-radius: var(--radius-sm) var(--radius-sm) 0 0;
      transition: all 0.15s;
      position: relative;
    }
    .pos-tab-btn:hover {
      color: #FFFFFF;
      background: rgba(255, 255, 255, 0.06);
    }
    .pos-tab-btn.active {
      color: var(--primary);
      background: var(--canvas);
      font-weight: 700;
    }
    .pos-tab-btn.active::after {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: var(--primary);
      border-radius: 3px 3px 0 0;
    }

    .badge-counter {
      background: var(--accent-warm);
      color: #FFFFFF;
      font-size: 11px;
      font-weight: 700;
      padding: 2px 7px;
      border-radius: var(--radius-pill);
      min-width: 18px;
      text-align: center;
    }

    .pos-header-meta {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .outlet-selector {
      background: var(--primary-dark);
      border: 1px solid rgba(255, 255, 255, 0.18);
      color: #FFFFFF;
      padding: 6px 12px;
      border-radius: var(--radius-sm);
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
    }

    .pos-body {
      flex: 1;
      display: flex;
      overflow: hidden;
      background: var(--canvas);
    }

    /* POS SCREEN 1: KASIR */
    .pos-screen-kasir {
      display: flex;
      width: 100%;
      height: 100%;
      overflow: hidden;
    }

    .kasir-catalog {
      flex: 1;
      display: flex;
      flex-direction: column;
      border-right: 1px solid var(--border-color);
      overflow: hidden;
      background: var(--canvas);
    }

    .catalog-toolbar {
      padding: 12px 18px;
      background: var(--surface);
      border-bottom: 1px solid var(--border-color);
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .search-box {
      display: flex;
      align-items: center;
      background: var(--surface-secondary);
      border: 1px solid var(--border-color);
      border-radius: var(--radius-sm);
      padding: 8px 12px;
      gap: 10px;
    }
    .search-box input {
      border: none;
      background: transparent;
      outline: none;
      font-size: 13px;
      width: 100%;
      color: var(--text-main);
    }

    .category-pills {
      display: flex;
      gap: 8px;
      overflow-x: auto;
    }
    .category-pill {
      white-space: nowrap;
      padding: 6px 14px;
      border-radius: var(--radius-sm);
      font-size: 12px;
      font-weight: 600;
      background: var(--surface-secondary);
      color: var(--text-secondary);
      border: 1px solid var(--border-color);
      transition: all 0.15s;
    }
    .category-pill:hover {
      background: var(--border-subtle);
    }
    .category-pill.active {
      background: var(--primary);
      color: #FFFFFF;
      border-color: var(--primary);
    }

    /* Product Grid */
    .product-grid {
      flex: 1;
      overflow-y: auto;
      padding: 16px;
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(154px, 1fr));
      gap: 12px;
      align-content: flex-start;
    }

    .product-card {
      background: var(--surface);
      border: 1px solid var(--border-color);
      border-radius: var(--radius-md);
      overflow: hidden;
      display: flex;
      flex-direction: column;
      cursor: pointer;
      transition: transform 0.12s, box-shadow 0.12s, border-color 0.12s;
      position: relative;
    }
    .product-card:hover {
      transform: translateY(-2px);
      box-shadow: var(--shadow-md);
      border-color: var(--primary);
    }

    .product-thumb-wrap {
      width: 100%;
      height: 120px;
      background: #ECEFF1;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
    }
    .product-thumb-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }
    /* Fallback Initials Block (Moka Style) */
    .product-initials-fallback {
      width: 100%;
      height: 100%;
      background: #EDF2F0;
      color: var(--primary);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
      font-weight: 800;
      letter-spacing: 1px;
    }

    .product-badge-stock {
      position: absolute;
      top: 6px;
      right: 6px;
      font-size: 10px;
      font-weight: 700;
      padding: 2px 6px;
      border-radius: 3px;
      background: rgba(255, 255, 255, 0.92);
      color: var(--text-secondary);
      border: 1px solid var(--border-color);
      box-shadow: var(--shadow-xs);
    }

    .product-card-body {
      padding: 10px 12px;
      display: flex;
      flex-direction: column;
      gap: 4px;
      background: var(--surface);
    }
    .product-title {
      font-size: 13px;
      font-weight: 600;
      color: var(--text-main);
      line-height: 1.3;
      min-height: 34px;
    }
    .product-price {
      font-size: 13px;
      font-weight: 700;
      color: var(--primary);
    }

    /* Kasir Right Cart Panel (Moka Pattern) */
    .kasir-cart-panel {
      width: 380px;
      background: var(--surface);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      border-left: 1px solid var(--border-color);
    }

    .cart-header {
      padding: 12px 16px;
      border-bottom: 1px solid var(--border-color);
      display: flex;
      flex-direction: column;
      gap: 10px;
      background: var(--surface);
    }

    .order-type-selector {
      display: flex;
      background: var(--surface-secondary);
      border: 1px solid var(--border-color);
      border-radius: var(--radius-sm);
      padding: 2px;
    }
    .order-type-btn {
      flex: 1;
      text-align: center;
      padding: 6px 0;
      font-size: 12px;
      font-weight: 600;
      color: var(--text-secondary);
      border-radius: var(--radius-sm);
      transition: all 0.15s;
    }
    .order-type-btn.active {
      background: var(--primary);
      color: #FFFFFF;
    }

    .customer-table-bar {
      display: flex;
      gap: 8px;
    }
    .meta-tag-btn {
      flex: 1;
      padding: 7px 10px;
      background: var(--surface-secondary);
      border: 1px solid var(--border-color);
      border-radius: var(--radius-sm);
      font-size: 12px;
      font-weight: 600;
      color: var(--text-main);
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .meta-tag-btn:hover {
      border-color: var(--primary);
    }

    .cart-items-list {
      flex: 1;
      overflow-y: auto;
      padding: 12px 16px;
      display: flex;
      flex-direction: column;
      gap: 10px;
      background: var(--surface);
    }

    .cart-item {
      display: flex;
      justify-content: space-between;
      border-bottom: 1px solid var(--border-subtle);
      padding-bottom: 10px;
    }
    .cart-item-info {
      flex: 1;
    }
    .cart-item-name {
      font-size: 13px;
      font-weight: 600;
      color: var(--text-main);
    }
    .cart-item-notes {
      font-size: 11px;
      color: var(--text-muted);
      margin-top: 2px;
    }
    .cart-item-price {
      font-size: 12px;
      font-weight: 600;
      color: var(--text-secondary);
      margin-top: 4px;
    }

    .cart-qty-ctrl {
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .qty-btn {
      width: 24px;
      height: 24px;
      border-radius: var(--radius-sm);
      background: var(--surface-secondary);
      border: 1px solid var(--border-color);
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 13px;
      color: var(--text-secondary);
    }
    .qty-btn:hover {
      background: var(--border-color);
      color: var(--text-main);
    }

    .cart-summary {
      padding: 14px 16px;
      border-top: 1px solid var(--border-color);
      background: var(--surface-secondary);
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .summary-row {
      display: flex;
      justify-content: space-between;
      font-size: 12px;
      color: var(--text-secondary);
    }
    .summary-row.total {
      font-size: 16px;
      font-weight: 800;
      color: var(--text-main);
      padding-top: 8px;
      border-top: 1px dashed var(--border-color);
      margin-top: 4px;
    }

    .cart-actions {
      padding: 12px 16px;
      display: flex;
      gap: 8px;
      background: var(--surface);
      border-top: 1px solid var(--border-color);
    }
    .btn-secondary {
      flex: 1;
      padding: 12px;
      background: var(--surface-secondary);
      border: 1px solid var(--border-color);
      border-radius: var(--radius-sm);
      font-size: 13px;
      font-weight: 600;
      color: var(--text-main);
      text-align: center;
    }
    .btn-secondary:hover {
      background: var(--border-color);
    }
    .btn-pay {
      flex: 2;
      padding: 12px;
      background: var(--primary);
      color: #FFFFFF;
      border-radius: var(--radius-sm);
      font-size: 14px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      box-shadow: var(--shadow-sm);
      transition: background 0.15s;
    }
    .btn-pay:hover {
      background: var(--primary-hover);
    }

    /* POS SCREEN 2: PESANAN (KANBAN DRAG AND DROP) */
    .pos-screen-pesanan {
      display: flex;
      flex-direction: column;
      width: 100%;
      height: 100%;
      overflow: hidden;
      background: var(--canvas);
    }

    .pesanan-toolbar {
      padding: 12px 20px;
      background: var(--surface);
      border-bottom: 1px solid var(--border-color);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .pesanan-filters {
      display: flex;
      gap: 8px;
    }
    .pesanan-filter-btn {
      padding: 6px 14px;
      border-radius: var(--radius-sm);
      font-size: 12px;
      font-weight: 600;
      background: var(--surface-secondary);
      color: var(--text-secondary);
      border: 1px solid var(--border-color);
    }
    .pesanan-filter-btn.active {
      background: var(--primary);
      color: #FFFFFF;
      border-color: var(--primary);
    }

    .kanban-board {
      flex: 1;
      display: flex;
      gap: 14px;
      padding: 16px 20px;
      overflow-x: auto;
    }

    .kanban-col {
      flex: 1;
      min-width: 260px;
      background: #ECEFF1;
      border-radius: var(--radius-md);
      border: 1px solid var(--border-color);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      transition: background 0.2s, border-color 0.2s;
    }
    .kanban-col.drag-over {
      background: #E0EAE5;
      border: 1px dashed var(--primary);
    }

    .kanban-col-header {
      padding: 10px 14px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 700;
      font-size: 13px;
      border-bottom: 1px solid var(--border-color);
      background: var(--surface);
      color: var(--text-main);
    }

    .kanban-cards {
      flex: 1;
      overflow-y: auto;
      padding: 10px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .order-card {
      background: var(--surface);
      border-radius: var(--radius-sm);
      border: 1px solid var(--border-color);
      padding: 12px;
      display: flex;
      flex-direction: column;
      gap: 6px;
      box-shadow: var(--shadow-xs);
      cursor: grab;
      user-select: none;
      transition: box-shadow 0.15s, opacity 0.15s, border-color 0.15s;
    }
    .order-card:active {
      cursor: grabbing;
    }
    .order-card.dragging {
      opacity: 0.45;
      border: 1px dashed var(--primary);
      box-shadow: var(--shadow-md);
    }
    .order-card.highlight-new {
      border-color: var(--accent-warm);
      box-shadow: 0 0 0 2px rgba(200, 109, 39, 0.25);
    }

    .order-card-top {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .order-badge-src {
      font-size: 10px;
      font-weight: 700;
      padding: 2px 6px;
      border-radius: 3px;
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    .badge-web {
      background: #EFF6FF;
      color: #1D4ED8;
      border: 1px solid #BFDBFE;
    }
    .badge-pos {
      background: #ECFDF5;
      color: #065F46;
      border: 1px solid #A7F3D0;
    }

    .order-id-label {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-main);
    }

    .order-items-preview {
      font-size: 12px;
      color: var(--text-secondary);
      line-height: 1.4;
    }

    .order-card-meta {
      display: flex;
      justify-content: space-between;
      font-size: 12px;
      color: var(--text-muted);
      border-top: 1px solid var(--border-subtle);
      padding-top: 6px;
      margin-top: 2px;
    }
    .order-card-meta strong {
      color: var(--text-main);
    }

    .order-card-actions {
      display: flex;
      gap: 6px;
      margin-top: 4px;
    }
    .btn-card-action {
      flex: 1;
      padding: 6px;
      border-radius: var(--radius-sm);
      font-size: 11px;
      font-weight: 600;
      text-align: center;
      transition: background 0.15s;
    }
    .btn-action-primary {
      background: var(--primary);
      color: #FFFFFF;
    }
    .btn-action-primary:hover {
      background: var(--primary-hover);
    }
    .btn-action-secondary {
      background: var(--surface-secondary);
      border: 1px solid var(--border-color);
      color: var(--text-main);
    }
    .btn-action-secondary:hover {
      background: var(--border-color);
    }

    /* POS SCREEN 3: ACCOUNTING (ENTERPRISE MOKA BACK-OFFICE) */
    .pos-screen-accounting {
      display: flex;
      flex-direction: column;
      width: 100%;
      height: 100%;
      overflow: hidden;
      background: var(--canvas);
    }

    .accounting-subnav {
      background: var(--surface);
      border-bottom: 1px solid var(--border-color);
      padding: 0 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      height: 48px;
    }

    .acc-tabs {
      display: flex;
      gap: 16px;
      height: 100%;
    }
    .acc-tab-btn {
      height: 100%;
      display: flex;
      align-items: center;
      font-size: 13px;
      font-weight: 600;
      color: var(--text-secondary);
      border-bottom: 3px solid transparent;
      padding: 0 2px;
    }
    .acc-tab-btn:hover {
      color: var(--primary);
    }
    .acc-tab-btn.active {
      color: var(--primary);
      border-color: var(--primary);
      font-weight: 700;
    }

    .mode-toggle-wrap {
      display: flex;
      align-items: center;
      gap: 8px;
      background: var(--surface-secondary);
      padding: 4px 10px;
      border-radius: var(--radius-sm);
      border: 1px solid var(--border-color);
      font-size: 12px;
      font-weight: 600;
    }
    .mode-toggle-switch {
      position: relative;
      width: 34px;
      height: 18px;
      background: #D1D5DB;
      border-radius: 10px;
      cursor: pointer;
      transition: background 0.25s;
    }
    .mode-toggle-switch.active {
      background: var(--primary);
    }
    .mode-toggle-dot {
      position: absolute;
      top: 2px;
      left: 2px;
      width: 14px;
      height: 14px;
      background: #FFFFFF;
      border-radius: 50%;
      transition: transform 0.25s;
    }
    .mode-toggle-switch.active .mode-toggle-dot {
      transform: translateX(16px);
    }

    .accounting-content-area {
      flex: 1;
      overflow-y: auto;
      padding: 18px 20px;
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    /* AI Financial Insight Banner (Sober & Professional) */
    .ai-insight-box {
      background: #FDFBF7;
      border: 1px solid #EADCC8;
      border-left: 4px solid var(--accent-warm);
      border-radius: var(--radius-sm);
      padding: 12px 16px;
      display: flex;
      align-items: center;
      gap: 12px;
      box-shadow: var(--shadow-xs);
    }
    .ai-insight-icon {
      color: var(--accent-warm);
      display: flex;
      align-items: center;
    }
    .ai-insight-text {
      flex: 1;
      font-size: 13px;
      color: #4A3A2A;
      line-height: 1.4;
    }
    .ai-insight-text strong {
      color: #1F2937;
    }

    /* KPI Metrics Cards Grid */
    .metrics-grid {
      display: grid;
      grid-template-columns: repeat(6, 1fr);
      gap: 12px;
    }
    .metric-card {
      background: var(--surface);
      border-radius: var(--radius-sm);
      border: 1px solid var(--border-color);
      padding: 14px;
      display: flex;
      flex-direction: column;
      gap: 4px;
      box-shadow: var(--shadow-xs);
    }
    .metric-label {
      font-size: 11px;
      font-weight: 600;
      color: var(--text-muted);
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    .metric-value {
      font-size: 18px;
      font-weight: 700;
      color: var(--text-main);
    }
    .metric-sub {
      font-size: 11px;
      font-weight: 600;
      color: var(--success);
    }

    .acc-subpanel {
      display: none;
      flex-direction: column;
      gap: 16px;
    }
    .acc-subpanel.active {
      display: flex;
    }

    /* Financial Tables */
    .table-card {
      background: var(--surface);
      border-radius: var(--radius-sm);
      border: 1px solid var(--border-color);
      overflow: hidden;
      box-shadow: var(--shadow-xs);
    }
    .table-card-header {
      padding: 12px 16px;
      background: var(--surface-secondary);
      border-bottom: 1px solid var(--border-color);
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 700;
      font-size: 13px;
    }
    .data-table {
      width: 100%;
      border-collapse: collapse;
      text-align: left;
      font-size: 13px;
    }
    .data-table th {
      background: #F8F9FA;
      color: var(--text-secondary);
      font-weight: 600;
      padding: 10px 14px;
      border-bottom: 1px solid var(--border-color);
      font-size: 12px;
    }
    .data-table td {
      padding: 10px 14px;
      border-bottom: 1px solid var(--border-subtle);
      color: var(--text-main);
    }
    .data-table tr:hover {
      background: var(--surface-hover);
    }
    .table-total-row {
      background: #F4F6F5 !important;
      font-weight: 700;
    }

    .reconciliation-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
    }
    .reconcile-match-badge {
      display: inline-block;
      padding: 2px 6px;
      border-radius: var(--radius-sm);
      font-size: 11px;
      font-weight: 600;
    }
    .badge-matched {
      background: var(--success-bg);
      color: var(--success);
      border: 1px solid var(--success-border);
    }
    .badge-diff {
      background: var(--warning-bg);
      color: var(--warning);
      border: 1px solid var(--warning-border);
    }

    /* ==========================================================================
       LOKO ORDER — MOBILE INTERFACE (KOPI KENANGAN FLOW + REAL PHOTOS)
       ========================================================================== */
    .order-mobile-app {
      flex: 1;
      display: flex;
      flex-direction: column;
      background: #F5F6F8;
      overflow: hidden;
      color: var(--text-main);
    }

    .order-app-body {
      flex: 1;
      overflow-y: auto;
      padding-bottom: 75px;
    }

    .order-hero-banner {
      background: var(--primary);
      color: #FFFFFF;
      padding: 20px 18px 26px 18px;
      border-radius: 0 0 20px 20px;
      position: relative;
    }
    .order-user-greet {
      font-size: 12px;
      color: #BCD5CA;
    }
    .order-user-name {
      font-size: 18px;
      font-weight: 700;
      color: #FFFFFF;
      margin-top: 2px;
    }

    .service-pickup-card {
      background: var(--surface);
      border-radius: var(--radius-md);
      padding: 12px;
      margin: -16px 14px 12px 14px;
      box-shadow: var(--shadow-sm);
      display: flex;
      flex-direction: column;
      gap: 10px;
      position: relative;
      z-index: 10;
      border: 1px solid var(--border-color);
    }
    .service-types-row {
      display: flex;
      background: var(--surface-secondary);
      border-radius: var(--radius-sm);
      padding: 2px;
    }
    .service-btn {
      flex: 1;
      padding: 7px 0;
      text-align: center;
      font-size: 12px;
      font-weight: 600;
      color: var(--text-secondary);
      border-radius: var(--radius-sm);
    }
    .service-btn.active {
      background: var(--primary);
      color: #FFFFFF;
    }

    .selected-outlet-info {
      display: flex;
      align-items: center;
      justify-content: space-between;
      border-top: 1px dashed var(--border-color);
      padding-top: 8px;
    }
    .outlet-name-title {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-main);
    }
    .outlet-dist-sub {
      font-size: 11px;
      color: var(--text-muted);
    }

    .points-bar-banner {
      margin: 0 14px 12px 14px;
      background: #FDFBF7;
      border: 1px solid #EADCC8;
      border-radius: var(--radius-sm);
      padding: 8px 12px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 12px;
    }
    .point-val {
      font-weight: 700;
      color: var(--accent-warm);
    }

    .order-category-scroll {
      display: flex;
      gap: 8px;
      padding: 0 14px 10px 14px;
      overflow-x: auto;
    }
    .order-cat-item {
      padding: 5px 12px;
      border-radius: var(--radius-sm);
      background: var(--surface);
      font-size: 12px;
      font-weight: 600;
      color: var(--text-secondary);
      white-space: nowrap;
      border: 1px solid var(--border-color);
    }
    .order-cat-item.active {
      background: var(--primary);
      color: #FFFFFF;
      border-color: var(--primary);
    }

    .order-products-container {
      padding: 0 14px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    .order-product-card {
      background: var(--surface);
      border-radius: var(--radius-sm);
      padding: 10px;
      display: flex;
      gap: 12px;
      box-shadow: var(--shadow-xs);
      cursor: pointer;
      border: 1px solid var(--border-color);
    }
    .order-prod-thumb {
      width: 72px;
      height: 72px;
      background: #ECEFF1;
      border-radius: var(--radius-sm);
      overflow: hidden;
      flex-shrink: 0;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .order-prod-thumb img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .order-prod-details {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }
    .order-prod-name {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-main);
    }
    .order-prod-desc {
      font-size: 11px;
      color: var(--text-muted);
    }
    .order-prod-price {
      font-size: 13px;
      font-weight: 700;
      color: var(--primary);
    }

    .order-floating-cart-bar {
      position: absolute;
      bottom: 16px;
      left: 14px;
      right: 14px;
      background: var(--primary);
      color: #FFFFFF;
      border-radius: var(--radius-sm);
      padding: 12px 18px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: var(--shadow-lg);
      cursor: pointer;
      z-index: 50;
      transition: transform 0.15s;
    }
    .order-floating-cart-bar:hover {
      transform: translateY(-2px);
    }

    .order-subpage {
      position: absolute;
      top: 42px;
      left: 0;
      right: 0;
      bottom: 0;
      background: var(--surface);
      z-index: 100;
      display: none;
      flex-direction: column;
      overflow-y: auto;
    }
    .order-subpage.active {
      display: flex;
    }
    .subpage-header {
      padding: 12px 16px;
      border-bottom: 1px solid var(--border-color);
      display: flex;
      align-items: center;
      gap: 12px;
      font-weight: 700;
      font-size: 15px;
      background: var(--surface);
      position: sticky;
      top: 0;
      z-index: 10;
    }

    .tracking-stepper {
      display: flex;
      flex-direction: column;
      gap: 18px;
      padding: 20px 16px;
    }
    .step-item {
      display: flex;
      gap: 14px;
      align-items: flex-start;
    }
    .step-indicator {
      width: 26px;
      height: 26px;
      border-radius: 50%;
      background: var(--border-color);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: 700;
      color: var(--text-muted);
    }
    .step-item.active .step-indicator {
      background: var(--primary);
      color: #FFFFFF;
      box-shadow: 0 0 0 3px var(--primary-light);
    }
    .step-item.done .step-indicator {
      background: var(--success);
      color: #FFFFFF;
    }
    .step-desc h4 {
      font-size: 13px;
      font-weight: 700;
    }
    .step-desc p {
      font-size: 11px;
      color: var(--text-muted);
      margin-top: 2px;
    }

    .mobile-push-banner {
      position: absolute;
      top: 50px;
      left: 12px;
      right: 12px;
      background: #11281E;
      color: #FFFFFF;
      border-radius: var(--radius-md);
      padding: 12px 14px;
      display: flex;
      gap: 10px;
      align-items: center;
      box-shadow: var(--shadow-lg);
      z-index: 1000;
      transform: translateY(-150%);
      transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1);
      border: 1px solid rgba(255, 255, 255, 0.12);
    }
    .mobile-push-banner.show {
      transform: translateY(0);
    }
    .push-app-icon {
      width: 28px;
      height: 28px;
      background: var(--primary);
      border-radius: var(--radius-sm);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #6EE7B7;
    }
    .push-content h5 {
      font-size: 12px;
      font-weight: 700;
      color: #F8B478;
    }
    .push-content p {
      font-size: 11px;
      color: #E2DDD3;
      margin-top: 1px;
    }

    /* ==========================================================================
       LOKO ASSISTANT (WHATSAPP CHATBOT MOCKUP)
       ========================================================================== */
    .wa-chat-app {
      flex: 1;
      display: flex;
      flex-direction: column;
      background: #EFEAE2;
      overflow: hidden;
      position: relative;
    }

    .wa-header {
      background: #075E54;
      color: #FFFFFF;
      padding: 10px 14px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
    }
    .wa-user-avatar {
      width: 38px;
      height: 38px;
      border-radius: 50%;
      background: #128C7E;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #FFFFFF;
      border: 1px solid rgba(255, 255, 255, 0.2);
    }
    .wa-user-info {
      flex: 1;
    }
    .wa-user-name {
      font-size: 14px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 4px;
    }
    .wa-verified {
      color: #25D366;
      font-size: 13px;
    }
    .wa-status {
      font-size: 11px;
      color: #C8E6C9;
    }

    .wa-persona-bar {
      background: #054D44;
      padding: 6px 12px;
      display: flex;
      gap: 6px;
    }
    .persona-chip {
      padding: 4px 10px;
      border-radius: var(--radius-sm);
      font-size: 11px;
      font-weight: 600;
      background: rgba(255, 255, 255, 0.15);
      color: #E0F2F1;
      cursor: pointer;
    }
    .persona-chip.active {
      background: #25D366;
      color: #075E54;
      font-weight: 700;
    }

    .wa-messages-container {
      flex: 1;
      overflow-y: auto;
      padding: 12px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .wa-msg {
      max-width: 85%;
      padding: 8px 12px;
      border-radius: 8px;
      font-size: 13px;
      line-height: 1.4;
      position: relative;
      box-shadow: 0 1px 1px rgba(0,0,0,0.1);
    }
    .wa-msg-in {
      align-self: flex-start;
      background: #FFFFFF;
      border-top-left-radius: 2px;
    }
    .wa-msg-out {
      align-self: flex-end;
      background: #E7FFDB;
      border-top-right-radius: 2px;
    }
    .wa-msg-time {
      font-size: 10px;
      color: #888888;
      text-align: right;
      margin-top: 4px;
    }

    .wa-quick-replies {
      padding: 8px 12px;
      display: flex;
      gap: 6px;
      overflow-x: auto;
      background: rgba(239, 234, 226, 0.95);
      border-top: 1px solid rgba(0, 0, 0, 0.06);
    }
    .wa-chip-btn {
      white-space: nowrap;
      background: #FFFFFF;
      color: #075E54;
      border: 1px solid #128C7E;
      padding: 5px 12px;
      border-radius: var(--radius-pill);
      font-size: 12px;
      font-weight: 600;
      transition: all 0.15s;
    }
    .wa-chip-btn:hover {
      background: #128C7E;
      color: #FFFFFF;
    }

    .wa-input-bar {
      background: #F0F2F5;
      padding: 8px 12px;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .wa-text-input {
      flex: 1;
      background: #FFFFFF;
      border: 1px solid #E4E6EB;
      border-radius: var(--radius-pill);
      padding: 8px 14px;
      font-size: 13px;
      outline: none;
    }
    .wa-send-btn {
      width: 34px;
      height: 34px;
      border-radius: 50%;
      background: #075E54;
      color: #FFFFFF;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
    }

    /* ==========================================================================
       MODALS, RECEIPT & TOASTS
       ========================================================================== */
    .modal-overlay {
      position: fixed;
      inset: 0;
      background: rgba(17, 24, 39, 0.6);
      backdrop-filter: blur(2px);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 2000;
      padding: 16px;
    }
    .modal-overlay.active {
      display: flex;
    }

    .modal-card {
      background: var(--surface);
      border-radius: var(--radius-md);
      width: 100%;
      max-width: 500px;
      max-height: 90vh;
      overflow-y: auto;
      box-shadow: var(--shadow-lg);
      display: flex;
      flex-direction: column;
      border: 1px solid var(--border-color);
    }
    .modal-header {
      padding: 14px 18px;
      border-bottom: 1px solid var(--border-color);
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 700;
      font-size: 15px;
    }
    .modal-body {
      padding: 18px;
      display: flex;
      flex-direction: column;
      gap: 14px;
    }
    .modal-footer {
      padding: 14px 18px;
      border-top: 1px solid var(--border-color);
      display: flex;
      justify-content: flex-end;
      gap: 8px;
      background: var(--surface-secondary);
    }

    .receipt-paper {
      background: #FFFFFF;
      border: 1px solid #D1D5DB;
      padding: 20px 16px;
      font-family: "Courier New", Courier, monospace;
      font-size: 12px;
      color: #111827;
      display: flex;
      flex-direction: column;
      gap: 8px;
      box-shadow: var(--shadow-xs);
    }

    .toast-accounting-wow {
      position: fixed;
      bottom: 24px;
      right: 24px;
      background: #0B2117;
      border: 1px solid #1E5C44;
      border-left: 4px solid #10B981;
      color: #FFFFFF;
      border-radius: var(--radius-sm);
      padding: 12px 18px;
      box-shadow: var(--shadow-lg);
      display: none;
      align-items: center;
      gap: 12px;
      z-index: 3000;
    }
    .toast-accounting-wow.show {
      display: flex;
    }

    .pitch-guide-drawer {
      position: fixed;
      top: 56px;
      right: -420px;
      width: 400px;
      height: calc(100vh - 56px);
      background: var(--surface);
      border-left: 1px solid var(--border-color);
      box-shadow: var(--shadow-lg);
      z-index: 1500;
      display: flex;
      flex-direction: column;
      transition: right 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    }
    .pitch-guide-drawer.open {
      right: 0;
    }
    .guide-header {
      padding: 14px 18px;
      background: var(--primary);
      color: #FFFFFF;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .guide-steps-list {
      flex: 1;
      overflow-y: auto;
      padding: 14px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    .guide-step-card {
      border: 1px solid var(--border-color);
      border-radius: var(--radius-sm);
      padding: 12px;
      background: var(--surface-secondary);
      cursor: pointer;
    }
    .guide-step-card.active {
      border-color: var(--primary);
      background: var(--primary-light);
    }
    .guide-step-title {
      font-size: 13px;
      font-weight: 700;
      color: var(--primary);
    }
    .guide-step-desc {
      font-size: 12px;
      color: var(--text-secondary);
      margin-top: 3px;
      line-height: 1.4;
    }
  </style>
</head>
<body>

  <!-- ========================================================================
       TOP PRESENTER TOOLBAR
       ======================================================================== -->
  <header class="presenter-bar">
    <div class="brand-group">
      <div class="brand-badge">
        <svg class="ui-icon" viewBox="0 0 24 24"><path d="M18 8h1a4 4 0 0 1 0 8h-1"></path><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path><line x1="6" y1="1" x2="6" y2="4"></line><line x1="10" y1="1" x2="10" y2="4"></line><line x1="14" y1="1" x2="14" y2="4"></line></svg>
        LOKO COFFEE
      </div>
      <div class="brand-title">POS + Pembukuan <strong>Otomatis</strong></div>
    </div>

    <div class="device-switcher">
      <button class="switcher-btn active" id="btnSwitchPos" onclick="switchDevice('pos')">
        <svg class="ui-icon" viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
        Loko POS (Tablet)
      </button>
      <button class="switcher-btn" id="btnSwitchOrder" onclick="switchDevice('order')">
        <svg class="ui-icon" viewBox="0 0 24 24"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"></rect><line x1="12" y1="18" x2="12.01" y2="18"></line></svg>
        Loko Order (Mobile)
      </button>
      <button class="switcher-btn" id="btnSwitchAssistant" onclick="switchDevice('assistant')">
        <svg class="ui-icon" viewBox="0 0 24 24"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path></svg>
        Loko Assistant (WA)
      </button>
    </div>

    <div class="toolbar-actions">
      <button class="tool-pill tax-toggle-btn" id="btnTaxToggle" onclick="toggleTaxMode()">
        Pajak: <span id="taxModeLabel">PPN 11%</span>
      </button>
      <button class="tool-pill" onclick="resetDemoData()" title="Kembalikan semua angka ke awal">
        <svg class="ui-icon" viewBox="0 0 24 24"><polyline points="1 4 1 10 7 10"></polyline><polyline points="23 20 23 14 17 14"></polyline><path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"></path></svg>
        Reset Demo
      </button>
      <button class="tool-pill btn-guide" onclick="togglePitchGuide()">
        <svg class="ui-icon" viewBox="0 0 24 24"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
        Alur Pitching (7 Langkah)
      </button>
    </div>
  </header>

  <!-- ========================================================================
       MAIN APP WORKSPACE
       ======================================================================== -->
  <main class="app-viewport-container">

    <!-- ======================================================================
         1. LOKO POS (Tablet Landscape View — Moka Pattern)
         ====================================================================== -->
    <div class="frame-tablet view-panel active" id="viewPos">
      
      <!-- POS Main Header -->
      <div class="pos-header">
        <div class="pos-nav-tabs">
          <button class="pos-tab-btn active" id="tabBtnKasir" onclick="switchPosTab('kasir')">
            <svg class="ui-icon" viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
            Kasir
          </button>
          <button class="pos-tab-btn" id="tabBtnPesanan" onclick="switchPosTab('pesanan')">
            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
            Pesanan
            <span class="badge-counter tabular-nums" id="posOrderCount">3</span>
          </button>
          <button class="pos-tab-btn" id="tabBtnAccounting" onclick="switchPosTab('accounting')">
            <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
            Accounting
            <span style="font-size:10px; background:var(--primary); color:#FFF; padding:1px 5px; border-radius:3px; margin-left:4px; font-weight:700;">AUTO</span>
          </button>
        </div>

        <div class="pos-header-meta">
          <select class="outlet-selector" id="posOutletSelect" onchange="changeOutlet(this.value)">
            <option value="braga">Outlet Braga</option>
            <option value="dago">Outlet Dago</option>
            <option value="all">Semua Cabang (Gabungan)</option>
          </select>

          <span style="font-size:12px; color:#A3C2B4; display:flex; align-items:center; gap:6px;">
            <span style="width:7px; height:7px; border-radius:50%; background:#10B981;"></span>
            Online
          </span>

          <button class="tool-pill" onclick="openShiftModal()" style="background:rgba(255,255,255,0.12); color:#FFF; font-weight:600;">
            Shift: Budi (Pagi)
          </button>

          <button onclick="openSettingsModal()" style="color:#B2D1C5;" title="Pengaturan & Audit">
            <svg class="ui-icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
          </button>
        </div>
      </div>

      <!-- POS Body -->
      <div class="pos-body">

        <!-- TAB 1: KASIR -->
        <div class="pos-screen-kasir" id="posScreenKasir">
          <div class="kasir-catalog">
            <div class="catalog-toolbar">
              <div class="search-box">
                <svg class="ui-icon" style="color:var(--text-muted);" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                <input type="text" id="catalogSearchInput" placeholder="Cari menu kopi, artisan pastry, atau makanan..." oninput="filterCatalog()">
              </div>
              <div class="category-pills">
                <button class="category-pill active" onclick="filterCategory('all', this)">Semua Menu</button>
                <button class="category-pill" onclick="filterCategory('kopi', this)">Kopi Susu & Espresso</button>
                <button class="category-pill" onclick="filterCategory('nonkopi', this)">Non-Kopi</button>
                <button class="category-pill" onclick="filterCategory('makanan', this)">Pastry & Makanan</button>
              </div>
            </div>

            <!-- Product Grid -->
            <div class="product-grid" id="productGrid">
              <!-- Rendered via JS -->
            </div>
          </div>

          <!-- Fixed Right Cart Panel -->
          <div class="kasir-cart-panel">
            <div class="cart-header">
              <div class="order-type-selector">
                <button class="order-type-btn active" onclick="setOrderType('Dine-in', this)">Dine-in</button>
                <button class="order-type-btn" onclick="setOrderType('Takeaway', this)">Takeaway</button>
                <button class="order-type-btn" onclick="setOrderType('Delivery', this)">Delivery</button>
              </div>

              <div class="customer-table-bar">
                <button class="meta-tag-btn" onclick="openTableModal()">
                  <span id="labelSelectedTable">Meja: 03</span>
                  <svg class="ui-icon" style="color:var(--text-muted);" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
                <button class="meta-tag-btn" onclick="openCustomerModal()">
                  <span id="labelSelectedCustomer">Pelanggan: Umum</span>
                  <svg class="ui-icon" style="color:var(--text-muted);" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
              </div>
            </div>

            <div class="cart-items-list" id="posCartList">
              <!-- Injected via JS -->
            </div>

            <div class="cart-summary">
              <div class="summary-row">
                <span>Subtotal</span>
                <span class="tabular-nums" id="posSubtotal">Rp0</span>
              </div>
              <div class="summary-row">
                <span>Diskon Promo</span>
                <span class="tabular-nums" id="posDiscount" style="color:var(--success);">-Rp0</span>
              </div>
              <div class="summary-row">
                <span id="posTaxLabel">PPN (11%)</span>
                <span class="tabular-nums" id="posTax">Rp0</span>
              </div>
              <div class="summary-row total">
                <span>Total Tagihan</span>
                <span class="tabular-nums" id="posGrandTotal" style="color:var(--primary);">Rp0</span>
              </div>
            </div>

            <div class="cart-actions">
              <button class="btn-secondary" onclick="holdCurrentCart()">
                Simpan
              </button>
              <button class="btn-pay" onclick="openPaymentModal()">
                Bayar Sekarang
              </button>
            </div>
          </div>
        </div>

        <!-- TAB 2: PESANAN (KANBAN DRAG AND DROP) -->
        <div class="pos-screen-pesanan" id="posScreenPesanan" style="display:none;">
          <div class="pesanan-toolbar">
            <div class="pesanan-filters">
              <button class="pesanan-filter-btn active" onclick="filterOrderType('all', this)">Semua Pesanan</button>
              <button class="pesanan-filter-btn" onclick="filterOrderType('Dine-in', this)">Dine-in</button>
              <button class="pesanan-filter-btn" onclick="filterOrderType('Pickup', this)">Takeaway / Pickup</button>
              <button class="pesanan-filter-btn" onclick="filterOrderType('Delivery', this)">Delivery</button>
              <button class="pesanan-filter-btn" onclick="filterOrderType('Online', this)">Web Order</button>
            </div>
            <div style="font-size:12px; color:var(--text-muted); display:flex; align-items:center; gap:6px;">
              <svg class="ui-icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
              Tarik & Letakkan (Drag & Drop) kartu antar kolom untuk update status
            </div>
          </div>

          <div class="kanban-board">
            <!-- Col 1: Baru -->
            <div class="kanban-col" id="kanbanColBaru" ondragover="allowDrop(event)" ondragleave="dragLeave(event)" ondrop="drop(event, 'baru')">
              <div class="kanban-col-header" style="border-top:3px solid var(--accent-warm);">
                <span>Pesanan Baru</span>
                <span class="badge-counter tabular-nums" id="countColBaru">1</span>
              </div>
              <div class="kanban-cards" id="colBaruCards">
                <!-- Cards injected here -->
              </div>
            </div>

            <!-- Col 2: Diproses -->
            <div class="kanban-col" id="kanbanColProses" ondragover="allowDrop(event)" ondragleave="dragLeave(event)" ondrop="drop(event, 'proses')">
              <div class="kanban-col-header" style="border-top:3px solid var(--info);">
                <span>Diproses Barista</span>
                <span class="badge-counter tabular-nums" id="countColProses" style="background:var(--info);">1</span>
              </div>
              <div class="kanban-cards" id="colProsesCards">
                <!-- Cards injected here -->
              </div>
            </div>

            <!-- Col 3: Siap -->
            <div class="kanban-col" id="kanbanColSiap" ondragover="allowDrop(event)" ondragleave="dragLeave(event)" ondrop="drop(event, 'siap')">
              <div class="kanban-col-header" style="border-top:3px solid var(--success);">
                <span>Siap Diambil / Antar</span>
                <span class="badge-counter tabular-nums" id="countColSiap" style="background:var(--success);">1</span>
              </div>
              <div class="kanban-cards" id="colSiapCards">
                <!-- Cards injected here -->
              </div>
            </div>

            <!-- Col 4: Selesai -->
            <div class="kanban-col" id="kanbanColSelesai" ondragover="allowDrop(event)" ondragleave="dragLeave(event)" ondrop="drop(event, 'selesai')">
              <div class="kanban-col-header" style="border-top:3px solid var(--text-muted);">
                <span>Selesai</span>
                <span class="badge-counter tabular-nums" id="countColSelesai" style="background:var(--text-muted);">124</span>
              </div>
              <div class="kanban-cards" id="colSelesaiCards">
                <!-- Cards injected here -->
              </div>
            </div>
          </div>
        </div>

        <!-- TAB 3: ACCOUNTING (MOKA BACK-OFFICE PATTERN) -->
        <div class="pos-screen-accounting" id="posScreenAccounting" style="display:none;">
          <div class="accounting-subnav">
            <div class="acc-tabs">
              <button class="acc-tab-btn active" onclick="switchAccSubtab('dashboard', this)">Dashboard Keuangan</button>
              <button class="acc-tab-btn" onclick="switchAccSubtab('journal', this)">Jurnal Otomatis</button>
              <button class="acc-tab-btn" onclick="switchAccSubtab('financials', this)">Laba Rugi & Neraca</button>
              <button class="acc-tab-btn" onclick="switchAccSubtab('reconcile', this)">Rekonsiliasi Bank</button>
              <button class="acc-tab-btn" onclick="switchAccSubtab('cogs', this)">HPP & Resep</button>
              <button class="acc-tab-btn" onclick="switchAccSubtab('expenses', this)">Biaya & Pajak</button>
            </div>

            <div class="mode-toggle-wrap">
              <span id="modeToggleLabel">Tampilan Sederhana</span>
              <div class="mode-toggle-switch" id="accModeSwitch" onclick="toggleAccMode()">
                <div class="mode-toggle-dot"></div>
              </div>
              <span style="color:var(--text-muted); font-size:11px;">Mode Akuntan</span>
            </div>
          </div>

          <div class="accounting-content-area">
            <!-- AI Financial Insight -->
            <div class="ai-insight-box">
              <div class="ai-insight-icon">
                <svg class="ui-icon ui-icon-lg" viewBox="0 0 24 24"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"></path></svg>
              </div>
              <div class="ai-insight-text">
                <strong>Insight AI Finansial Loko:</strong> 
                Omzet harian Loko Braga melampaui target +14%. Penjualan <em>Aren Latte & Butter Croissant</em> menyumbang 38% margin kotor. 
                <span id="aiInsightDynamic">Biaya bahan baku stabil. Rekomendasi: Pertahankan paket bundling kopi + donat pada jam makan siang.</span>
              </div>
            </div>

            <!-- Subpanel 1: Dashboard -->
            <div class="acc-subpanel active" id="accSubDashboard">
              <div class="metrics-grid">
                <div class="metric-card">
                  <div class="metric-label">Omzet Hari Ini</div>
                  <div class="metric-value tabular-nums" id="metricOmzetHariIni">Rp5.940.000</div>
                  <div class="metric-sub">▲ +12.4% vs kemarin</div>
                </div>
                <div class="metric-card">
                  <div class="metric-label">HPP (COGS 35%)</div>
                  <div class="metric-value tabular-nums" id="metricHppHariIni">Rp2.079.000</div>
                  <div class="metric-sub" style="color:var(--text-secondary);">Efisiensi optimal</div>
                </div>
                <div class="metric-card">
                  <div class="metric-label">Laba Kotor</div>
                  <div class="metric-value tabular-nums" id="metricLabaKotorHariIni" style="color:var(--success);">Rp3.861.000</div>
                  <div class="metric-sub">Gross Margin: 65%</div>
                </div>
                <div class="metric-card">
                  <div class="metric-label">Kas & Bank Tersedia</div>
                  <div class="metric-value tabular-nums" id="metricKasTotal">Rp189.500.000</div>
                  <div class="metric-sub">Laci + BCA + QRIS</div>
                </div>
                <div class="metric-card">
                  <div class="metric-label">Laba Bersih Bulan Ini</div>
                  <div class="metric-value tabular-nums" id="metricLabaBersihBulanIni" style="color:var(--primary);">Rp65.250.000</div>
                  <div class="metric-sub">Net Margin: ~20.7%</div>
                </div>
                <div class="metric-card">
                  <div class="metric-label">Hutang Pajak Siap Setor</div>
                  <div class="metric-value tabular-nums" id="metricHutangPajak" style="color:var(--accent-warm);">Rp18.420.000</div>
                  <div class="metric-sub" id="metricPajakSub">PPN 11% + PPh 0.5%</div>
                </div>
              </div>

              <!-- Bar Comparisons -->
              <div style="display:grid; grid-template-columns: 2fr 1fr; gap:14px;">
                <div class="table-card">
                  <div class="table-card-header">
                    <span>Performa Penjualan: Loko Braga vs Loko Dago</span>
                    <span style="font-size:11px; color:var(--text-muted);">Hari Ini</span>
                  </div>
                  <div style="padding:18px; display:flex; flex-direction:column; gap:16px;">
                    <div>
                      <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:6px;">
                        <span><strong>Loko Braga</strong> (142 Transaksi · Rata-rata Rp41.800)</span>
                        <strong class="tabular-nums" id="omzetBragaBar">Rp5.940.000</strong>
                      </div>
                      <div style="width:100%; height:10px; background:#EEF0F2; border-radius:4px; overflow:hidden;">
                        <div style="width:58%; height:100%; background:var(--primary); border-radius:4px;"></div>
                      </div>
                    </div>

                    <div>
                      <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:6px;">
                        <span><strong>Loko Dago</strong> (114 Transaksi · Rata-rata Rp40.300)</span>
                        <strong class="tabular-nums" id="omzetDagoBar">Rp4.600.000</strong>
                      </div>
                      <div style="width:100%; height:10px; background:#EEF0F2; border-radius:4px; overflow:hidden;">
                        <div style="width:45%; height:100%; background:var(--accent-warm); border-radius:4px;"></div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="table-card">
                  <div class="table-card-header">
                    <span>Komposisi Pembayaran</span>
                  </div>
                  <div style="padding:16px; display:flex; flex-direction:column; gap:10px; font-size:12px;">
                    <div style="display:flex; justify-content:space-between;">
                      <span>QRIS Dinamis</span>
                      <strong class="tabular-nums">45% (Rp4.743.000)</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between;">
                      <span>Tunai Kasir</span>
                      <strong class="tabular-nums">35% (Rp3.689.000)</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between;">
                      <span>E-Wallet / EDC</span>
                      <strong class="tabular-nums">15% (Rp1.581.000)</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between;">
                      <span>Web Order Online</span>
                      <strong class="tabular-nums">5% (Rp527.000)</strong>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Subpanel 2: Jurnal Otomatis -->
            <div class="acc-subpanel" id="accSubJournal">
              <div class="table-card">
                <div class="table-card-header">
                  <div>
                    <span>Feed Jurnal Pembukuan Otomatis (Real-time Auto-Journaling)</span>
                    <div style="font-size:11px; font-weight:normal; color:var(--text-muted); margin-top:2px;">
                      Setiap kali kasir / web order memproses transaksi, jurnal akuntansi debit/kredit langsung dicatat tanpa perlu admin akunting.
                    </div>
                  </div>
                  <button class="tool-pill" onclick="simulateExportCSV('Jurnal_Loko_Coffee.csv')">
                    Ekspor CSV
                  </button>
                </div>
                <div style="max-height:480px; overflow-y:auto;">
                  <table class="data-table">
                    <thead>
                      <tr>
                        <th>Waktu & No Transaksi</th>
                        <th>Penjelasan Bisnis (Awam)</th>
                        <th class="col-account-mode" style="display:none;">Akun Debit / Kredit (COA)</th>
                        <th>Nominal</th>
                        <th>Status Jurnal</th>
                      </tr>
                    </thead>
                    <tbody id="journalTableBody">
                      <!-- Entries rendered via JS -->
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            <!-- Subpanel 3: Laba Rugi & Neraca -->
            <div class="acc-subpanel" id="accSubFinancials">
              <div style="display:grid; grid-template-columns: 1fr 1fr; gap:14px;">
                <div class="table-card">
                  <div class="table-card-header">
                    <span>Laporan Laba Rugi (P&L Bulanan)</span>
                    <button class="tool-pill" onclick="simulateExportCSV('Laba_Rugi_Loko.csv')">Unduh Excel</button>
                  </div>
                  <table class="data-table">
                    <tbody>
                      <tr><td><strong>PENDAPATAN USAHA</strong></td><td></td></tr>
                      <tr><td style="padding-left:24px;">Penjualan Minuman & Makanan</td><td id="plOmzet" class="tabular-nums" style="text-align:right;">Rp315.000.000</td></tr>
                      <tr class="table-total-row"><td>Total Pendapatan</td><td id="plTotalRevenue" class="tabular-nums" style="text-align:right;">Rp315.000.000</td></tr>
                      
                      <tr><td><strong>BEBAN POKOK PENDAPATAN (HPP)</strong></td><td></td></tr>
                      <tr><td style="padding-left:24px;">HPP Bahan Baku (Kopi, Susu, Pastry)</td><td id="plHpp" class="tabular-nums" style="text-align:right; color:var(--danger);">(Rp110.250.000)</td></tr>
                      <tr class="table-total-row"><td>LABA KOTOR (GROSS PROFIT)</td><td id="plGrossProfit" class="tabular-nums" style="text-align:right; color:var(--success);">Rp204.750.000</td></tr>
                      
                      <tr><td><strong>BIAYA OPERASIONAL</strong></td><td></td></tr>
                      <tr><td style="padding-left:24px;">Gaji & Tunjangan Barista/Staff (10 org)</td><td class="tabular-nums" style="text-align:right;">(Rp58.000.000)</td></tr>
                      <tr><td style="padding-left:24px;">Sewa Tempat (Braga & Dago)</td><td class="tabular-nums" style="text-align:right;">(Rp45.000.000)</td></tr>
                      <tr><td style="padding-left:24px;">Listrik, Air & Internet</td><td class="tabular-nums" style="text-align:right;">(Rp18.000.000)</td></tr>
                      <tr><td style="padding-left:24px;">Pemasaran & Diskon Promo</td><td class="tabular-nums" style="text-align:right;">(Rp12.000.000)</td></tr>
                      <tr><td style="padding-left:24px;">Beban Operasional Lain-lain</td><td class="tabular-nums" style="text-align:right;">(Rp6.750.000)</td></tr>
                      <tr class="table-total-row" style="background:#EBF5F0 !important; font-size:14px;">
                        <td>LABA BERSIH (NET INCOME)</td>
                        <td id="plNetProfit" class="tabular-nums" style="text-align:right; color:var(--primary); font-weight:800;">Rp65.000.000</td>
                      </tr>
                    </tbody>
                  </table>
                </div>

                <div class="table-card">
                  <div class="table-card-header">
                    <span>Laporan Neraca (Balance Sheet)</span>
                    <span style="font-size:11px; background:var(--success-bg); color:var(--success); border:1px solid var(--success-border); padding:2px 6px; border-radius:var(--radius-sm); font-weight:600;">
                      ✓ Neraca Seimbang
                    </span>
                  </div>
                  <table class="data-table">
                    <tbody>
                      <tr><td><strong>ASET (AKTIVA)</strong></td><td></td></tr>
                      <tr><td style="padding-left:24px;">Kas Laci & Rekening Bank BCA</td><td id="bsKas" class="tabular-nums" style="text-align:right;">Rp189.500.000</td></tr>
                      <tr><td style="padding-left:24px;">Piutang QRIS & E-Wallet Settlement</td><td class="tabular-nums" style="text-align:right;">Rp18.500.000</td></tr>
                      <tr><td style="padding-left:24px;">Persediaan Bahan Baku (Gudang)</td><td class="tabular-nums" style="text-align:right;">Rp42.000.000</td></tr>
                      <tr><td style="padding-left:24px;">Aset Tetap (Mesin Espresso, Interior)</td><td class="tabular-nums" style="text-align:right;">Rp180.000.000</td></tr>
                      <tr class="table-total-row"><td>TOTAL ASET</td><td id="bsTotalAssets" class="tabular-nums" style="text-align:right;">Rp430.000.000</td></tr>

                      <tr><td><strong>KEWAJIBAN & EKUITAS (PASIVA)</strong></td><td></td></tr>
                      <tr><td style="padding-left:24px;">Hutang Usaha Supplier Bahan</td><td class="tabular-nums" style="text-align:right;">Rp32.000.000</td></tr>
                      <tr><td style="padding-left:24px;">Hutang Pajak Siap Setor</td><td id="bsTaxLiab" class="tabular-nums" style="text-align:right;">Rp18.000.000</td></tr>
                      <tr><td style="padding-left:24px;">Modal Pemilik Disetor</td><td class="tabular-nums" style="text-align:right;">Rp315.000.000</td></tr>
                      <tr><td style="padding-left:24px;">Laba Ditahan Berjalan</td><td id="bsRetainedEarnings" class="tabular-nums" style="text-align:right;">Rp65.000.000</td></tr>
                      <tr class="table-total-row" style="background:#EBF5F0 !important;">
                        <td>TOTAL KEWAJIBAN & EKUITAS</td>
                        <td id="bsTotalLiabEquity" class="tabular-nums" style="text-align:right; font-weight:800; color:var(--primary);">Rp430.000.000</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            <!-- Subpanel 4: Rekonsiliasi Bank -->
            <div class="acc-subpanel" id="accSubReconcile">
              <div class="table-card">
                <div class="table-card-header">
                  <div>
                    <span>Rekonsiliasi Bank Otomatis (Loko vs Mutasi Rekening BCA)</span>
                    <div style="font-size:11px; font-weight:normal; color:var(--text-muted);">
                      Membandingkan mutasi penerimaan kasir & settlement QRIS dengan rekening koran mutasi bank.
                    </div>
                  </div>
                  <button class="btn-pay" style="padding:6px 14px; font-size:12px;" onclick="runAutoReconcile()">
                    Cocokkan Otomatis
                  </button>
                </div>

                <div class="reconciliation-grid" style="padding:16px;">
                  <div>
                    <h4 style="font-size:13px; margin-bottom:8px; color:var(--primary);">Catatan Pembukuan Loko</h4>
                    <table class="data-table" style="font-size:12px;">
                      <thead>
                        <tr><th>Tanggal</th><th>Deskripsi</th><th>Nominal</th><th>Status</th></tr>
                      </thead>
                      <tbody id="reconcileLokoBody">
                        <!-- Injected via JS -->
                      </tbody>
                    </table>
                  </div>

                  <div>
                    <h4 style="font-size:13px; margin-bottom:8px; color:#0A58CA;">Mutasi Rekening Bank BCA (014-XXXXXX)</h4>
                    <table class="data-table" style="font-size:12px;">
                      <thead>
                        <tr><th>Tanggal</th><th>Keterangan Bank</th><th>Nominal</th><th>Aksi</th></tr>
                      </thead>
                      <tbody id="reconcileBankBody">
                        <!-- Injected via JS -->
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <!-- Subpanel 5: HPP & Resep -->
            <div class="acc-subpanel" id="accSubCogs">
              <div class="table-card">
                <div class="table-card-header">
                  <div>
                    <span>Kalkulasi HPP Resep Akurat per Cangkir</span>
                    <div style="font-size:11px; font-weight:normal; color:var(--text-muted);">
                      Stok bahan otomatis terpotong berdasar resep. Metode: <strong>Average Costing</strong>.
                    </div>
                  </div>
                  <div style="display:flex; gap:6px;">
                    <button class="category-pill active">Metode: Average</button>
                    <button class="category-pill" onclick="alert('Beralih ke metode FIFO: Nilai persediaan dihitung dari batch pertama.')">FIFO</button>
                  </div>
                </div>
                <table class="data-table">
                  <thead>
                    <tr>
                      <th>Nama Menu</th>
                      <th>Bahan Baku Resep</th>
                      <th>Biaya Bahan (HPP)</th>
                      <th>Harga Jual</th>
                      <th>Margin Kotor (%)</th>
                      <th>Status Margin</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><strong>Kopi Susu Loko</strong></td>
                      <td>Kopi Espresso 18g, Susu Fresh 120ml, Gula Aren 25ml, Cup+Sedotan</td>
                      <td class="tabular-nums">Rp7.700</td>
                      <td class="tabular-nums">Rp22.000</td>
                      <td class="tabular-nums"><strong>65.0%</strong></td>
                      <td><span class="reconcile-match-badge badge-matched">Optimal</span></td>
                    </tr>
                    <tr>
                      <td><strong>Caramel Macchiato</strong></td>
                      <td>Espresso 18g, Susu Fresh 150ml, Sirup Karamel Impor 20ml, Drizzle</td>
                      <td class="tabular-nums">Rp13.400</td>
                      <td class="tabular-nums">Rp32.000</td>
                      <td class="tabular-nums"><strong>58.1%</strong></td>
                      <td><span class="reconcile-match-badge badge-matched">Sehat</span></td>
                    </tr>
                    <tr>
                      <td><strong>Butter Croissant</strong></td>
                      <td>Dough Croissant Artisan, Mentega Elle & Vire 30g</td>
                      <td class="tabular-nums">Rp11.200</td>
                      <td class="tabular-nums">Rp25.000</td>
                      <td class="tabular-nums"><strong>55.2%</strong></td>
                      <td><span class="reconcile-match-badge badge-matched">Sehat</span></td>
                    </tr>
                    <tr>
                      <td><strong>Americano</strong></td>
                      <td>Espresso Double Shot 36g, Air Mineral 200ml, Cup</td>
                      <td class="tabular-nums">Rp4.200</td>
                      <td class="tabular-nums">Rp20.000</td>
                      <td class="tabular-nums"><strong>79.0%</strong></td>
                      <td><span class="reconcile-match-badge badge-matched">Margin Tertinggi</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- Subpanel 6: Biaya & Pajak -->
            <div class="acc-subpanel" id="accSubExpenses">
              <div style="display:grid; grid-template-columns: 1fr 1fr; gap:14px;">
                <div class="table-card">
                  <div class="table-card-header">
                    <span>Catat Biaya Cepat (Petty Cash Outlet)</span>
                  </div>
                  <div style="padding:16px; display:flex; flex-direction:column; gap:12px;">
                    <div>
                      <label style="font-size:12px; font-weight:600;">Kategori Biaya</label>
                      <select id="expenseCategory" style="width:100%; padding:8px; border:1px solid var(--border-color); border-radius:var(--radius-sm); margin-top:4px;">
                        <option>Es Batu Kristal Tambahan (Operasional)</option>
                        <option>Gas LPG Dapur (Dapur)</option>
                        <option>Beli Bahan Darurat di Pasar</option>
                        <option>Uang Parkir & Sampah</option>
                      </select>
                    </div>
                    <div>
                      <label style="font-size:12px; font-weight:600;">Nominal Pengeluaran (Rp)</label>
                      <input type="number" id="expenseAmount" placeholder="Contoh: 35000" style="width:100%; padding:8px; border:1px solid var(--border-color); border-radius:var(--radius-sm); margin-top:4px;">
                    </div>
                    <div>
                      <label style="font-size:12px; font-weight:600;">Sumber Kas</label>
                      <select id="expenseSource" style="width:100%; padding:8px; border:1px solid var(--border-color); border-radius:var(--radius-sm); margin-top:4px;">
                        <option>Kas Laci Braga (Petty Cash)</option>
                        <option>Kas Laci Dago (Petty Cash)</option>
                        <option>Transfer Bank BCA</option>
                      </select>
                    </div>
                    <button class="btn-pay" style="padding:10px; font-size:13px;" onclick="submitExpense()">
                      + Catat Biaya & Potong Laba
                    </button>
                  </div>
                </div>

                <div class="table-card">
                  <div class="table-card-header">
                    <span>Laporan Siap Pajak (Bulan Ini)</span>
                    <button class="tool-pill" onclick="alert('Formulir SPT Masa siap diunduh.')">Siap Lapor</button>
                  </div>
                  <div style="padding:16px; display:flex; flex-direction:column; gap:12px; font-size:13px;">
                    <div style="display:flex; justify-content:space-between; border-bottom:1px solid var(--border-subtle); padding-bottom:8px;">
                      <span>DPP Penjualan Kena Pajak</span>
                      <strong class="tabular-nums" id="taxDpp">Rp315.000.000</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; border-bottom:1px solid var(--border-subtle); padding-bottom:8px;">
                      <span id="taxLabelSummary">PPN Terutang (11%)</span>
                      <strong class="tabular-nums" id="taxValSummary" style="color:var(--accent-warm);">Rp34.650.000</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; border-bottom:1px solid var(--border-subtle); padding-bottom:8px;">
                      <span>PPh Final UMKM (PP 55/2022 - 0.5%)</span>
                      <strong class="tabular-nums">Rp1.575.000</strong>
                    </div>
                    <div style="background:var(--success-bg); color:var(--success); border:1px solid var(--success-border); padding:10px; border-radius:var(--radius-sm); font-size:12px; line-height:1.4;">
                      ✓ Dihitung otomatis dari transaksi kasir. Siap diekspor ke e-Faktur & formulir SPT masa.
                    </div>
                  </div>
                </div>
              </div>
            </div>

          </div>
        </div>

      </div>
    </div>

    <!-- ======================================================================
         2. LOKO ORDER (Mobile Web — Kopi Kenangan Flow)
         ====================================================================== -->
    <div class="frame-mobile view-panel" id="viewOrder">
      <div class="phone-notch">
        <div class="phone-camera-lens"></div>
      </div>

      <div class="mobile-status-bar" style="color:#FFFFFF; background:var(--primary);">
        <span>09:41</span>
        <span style="display:flex; gap:6px; font-size:11px;">5G 98%</span>
      </div>

      <!-- Simulated Push Notification Banner -->
      <div class="mobile-push-banner" id="orderPushBanner">
        <div class="push-app-icon">
          <svg class="ui-icon" viewBox="0 0 24 24"><path d="M18 8h1a4 4 0 0 1 0 8h-1"></path><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path></svg>
        </div>
        <div class="push-content">
          <h5 id="pushBannerTitle">Pesanan Diterima!</h5>
          <p id="pushBannerBody">Barista Loko Braga sedang meracik kopimu.</p>
        </div>
      </div>

      <div class="order-mobile-app">
        <div class="order-app-body" id="orderAppBody">
          <div class="order-hero-banner">
            <div class="order-user-greet">Selamat datang di Loko Coffee,</div>
            <div class="order-user-name">Rian Pratama</div>
          </div>

          <!-- Pickup / Dine-in / Delivery Card -->
          <div class="service-pickup-card">
            <div class="service-types-row">
              <button class="service-btn active" onclick="setMobileService('pickup', this)">Pickup</button>
              <button class="service-btn" onclick="setMobileService('dinein', this)">Dine-in</button>
              <button class="service-btn" onclick="setMobileService('delivery', this)">Delivery</button>
            </div>
            
            <div class="selected-outlet-info">
              <div>
                <div class="outlet-name-title" id="orderOutletTitle">Loko Coffee — Braga</div>
                <div class="outlet-dist-sub" id="orderOutletDist">Jl. Braga No. 45 · 1.2 km dari lokasimu</div>
              </div>
              <button style="font-size:12px; font-weight:700; color:var(--primary);" onclick="toggleMobileOutlet()">
                Ganti Outlet
              </button>
            </div>
          </div>

          <div class="points-bar-banner">
            <div>
              <span>Loko Points: </span>
              <span class="point-val tabular-nums" id="orderUserPoints">14.500 Poin</span>
            </div>
            <span style="color:var(--accent-warm); font-weight:600; font-size:11px;">Tier Gold Bean</span>
          </div>

          <div class="order-category-scroll">
            <button class="order-cat-item active" onclick="filterMobileCategory('all', this)">Semua Menu</button>
            <button class="order-cat-item" onclick="filterMobileCategory('kopi', this)">Kopi Favorit</button>
            <button class="order-cat-item" onclick="filterMobileCategory('nonkopi', this)">Non-Kopi Segar</button>
            <button class="order-cat-item" onclick="filterMobileCategory('makanan', this)">Pastry & Donat</button>
          </div>

          <div class="order-products-container" id="orderProductList">
            <!-- Injected via JS -->
          </div>
        </div>

        <!-- Floating Cart Bar -->
        <div class="order-floating-cart-bar" id="orderFloatingCart" onclick="openOrderCheckout()" style="display:none;">
          <div style="display:flex; align-items:center; gap:8px;">
            <span style="background:rgba(255,255,255,0.2); border-radius:var(--radius-sm); padding:2px 8px; font-size:12px; font-weight:700;" id="orderCartCount">0</span>
            <span style="font-weight:600; font-size:13px;">Lihat Pesanan</span>
          </div>
          <div class="tabular-nums" style="font-weight:700; font-size:14px;" id="orderCartTotal">Rp0</div>
        </div>

        <!-- Subpage: Checkout -->
        <div class="order-subpage" id="orderSubpageCheckout">
          <div class="subpage-header">
            <button onclick="closeOrderSubpages()" style="display:flex; align-items:center;">
              <svg class="ui-icon" viewBox="0 0 24 24"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
            </button>
            <span>Konfirmasi Pesanan</span>
          </div>
          <div style="padding:16px; display:flex; flex-direction:column; gap:14px; flex:1;">
            <div style="background:var(--surface-secondary); border-radius:var(--radius-sm); padding:12px; border:1px solid var(--border-color);" id="orderCheckoutItems">
              <!-- Injected via JS -->
            </div>

            <div style="background:#FFF; border:1px solid var(--border-color); border-radius:var(--radius-sm); padding:10px 12px; display:flex; justify-content:space-between; align-items:center; font-size:13px;">
              <div>
                <strong>Waktu Pengambilan</strong>
                <div style="font-size:11px; color:var(--text-muted);">Langsung disiapkan oleh barista</div>
              </div>
              <span style="color:var(--primary); font-weight:700;">Sekarang (~8 Menit)</span>
            </div>

            <div style="display:flex; flex-direction:column; gap:8px;">
              <div style="display:flex; justify-content:space-between; align-items:center; background:#FFF; border:1px solid var(--border-color); border-radius:var(--radius-sm); padding:10px 12px; font-size:13px;">
                <span>Voucher: <strong>DISKONKOPI10 (10%)</strong></span>
                <span style="color:var(--success); font-weight:700;">Terpasang ✓</span>
              </div>

              <label style="display:flex; align-items:center; gap:8px; font-size:12px; cursor:pointer;">
                <input type="checkbox" id="chkUsePoints" onchange="calcMobileCartTotal()">
                <span>Tukarkan <strong>5.000 Loko Points</strong> (-Rp5.000)</span>
              </label>

              <label style="display:flex; align-items:center; gap:8px; font-size:12px; cursor:pointer;">
                <input type="checkbox" id="chkAddBag" onchange="calcMobileCartTotal()" checked>
                <span>Tambah Kantong Ramah Lingkungan (+Rp1.000)</span>
              </label>
            </div>

            <div>
              <label style="font-size:12px; font-weight:600; margin-bottom:6px; display:block;">Metode Pembayaran</label>
              <div style="display:flex; gap:6px;">
                <button class="order-cat-item active" style="flex:1;">QRIS Instan</button>
                <button class="order-cat-item" style="flex:1;">GoPay / OVO</button>
                <button class="order-cat-item" style="flex:1;">Virtual Account</button>
              </div>
            </div>

            <div style="border-top:1px dashed var(--border-color); padding-top:10px; display:flex; flex-direction:column; gap:6px; font-size:13px;">
              <div style="display:flex; justify-content:space-between;">
                <span>Subtotal Item</span>
                <span class="tabular-nums" id="chkSubtotal">Rp0</span>
              </div>
              <div style="display:flex; justify-content:space-between; color:var(--success);">
                <span>Potongan Diskon & Poin</span>
                <span class="tabular-nums" id="chkDiscount">-Rp0</span>
              </div>
              <div style="display:flex; justify-content:space-between;">
                <span id="chkTaxLabel">PPN 11%</span>
                <span class="tabular-nums" id="chkTax">Rp0</span>
              </div>
              <div style="display:flex; justify-content:space-between; font-size:15px; font-weight:800; border-top:1px solid var(--border-color); padding-top:6px; margin-top:4px;">
                <span>Total Pembayaran</span>
                <span class="tabular-nums" id="chkGrandTotal" style="color:var(--primary);">Rp0</span>
              </div>
            </div>

            <button class="btn-pay" onclick="submitMobileOrder()" style="padding:14px; width:100%; margin-top:auto;">
              Bayar Sekarang (Simulasi QRIS)
            </button>
          </div>
        </div>

        <!-- Subpage: Tracking -->
        <div class="order-subpage" id="orderSubpageTracking">
          <div class="subpage-header">
            <button onclick="closeOrderSubpages()" style="display:flex; align-items:center;">
              <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
            <span>Status Pesanan Real-time</span>
          </div>
          <div style="padding:20px; display:flex; flex-direction:column; gap:16px; flex:1;">
            <div style="background:var(--primary-light); border:1px solid var(--primary-border); border-radius:var(--radius-sm); padding:16px; text-align:center;">
              <div style="font-size:12px; color:var(--text-secondary);">Nomor Antrean Anda</div>
              <div style="font-size:26px; font-weight:800; color:var(--primary); margin:4px 0;" id="trackOrderNo">#LK-0145</div>
              <div style="font-size:12px; font-weight:600; color:var(--text-secondary);" id="trackETA">Estimasi Siap: ~6 Menit</div>
            </div>

            <div class="tracking-stepper">
              <div class="step-item done" id="step1">
                <div class="step-indicator">✓</div>
                <div class="step-desc">
                  <h4>Pesanan Diterima</h4>
                  <p>Pembayaran QRIS dikonfirmasi.</p>
                </div>
              </div>

              <div class="step-item active" id="step2">
                <div class="step-indicator">2</div>
                <div class="step-desc">
                  <h4>Barista Sedang Meracik</h4>
                  <p>Sedang disiapkan di Loko Coffee Braga.</p>
                </div>
              </div>

              <div class="step-item" id="step3">
                <div class="step-indicator">3</div>
                <div class="step-desc">
                  <h4>Siap Diambil di Pickup Counter</h4>
                  <p>Tunjukkan nomor antrean ke kasir.</p>
                </div>
              </div>

              <div class="step-item" id="step4">
                <div class="step-indicator">4</div>
                <div class="step-desc">
                  <h4>Pesanan Selesai</h4>
                  <p>Terima kasih atas pesananmu!</p>
                </div>
              </div>
            </div>

            <div style="margin-top:auto; display:flex; flex-direction:column; gap:8px;">
              <button class="btn-secondary" onclick="switchDevice('pos'); switchPosTab('pesanan');">
                Lihat Pesanan di POS Tab Pesanan ➔
              </button>
              <button class="btn-secondary" onclick="closeOrderSubpages()">
                Kembali ke Beranda
              </button>
            </div>
          </div>
        </div>

      </div>
    </div>

    <!-- ======================================================================
         3. LOKO ASSISTANT (WhatsApp AI Mockup)
         ====================================================================== -->
    <div class="frame-mobile view-panel" id="viewAssistant">
      <div class="phone-notch">
        <div class="phone-camera-lens"></div>
      </div>

      <div class="mobile-status-bar" style="color:#FFFFFF; background:#075E54;">
        <span>09:41</span>
        <span style="display:flex; gap:6px; font-size:11px;">5G 98%</span>
      </div>

      <div class="wa-chat-app">
        <div class="wa-header">
          <div style="display:flex; align-items:center; gap:8px;">
            <button onclick="switchDevice('pos')" style="color:#FFF;">
              <svg class="ui-icon" viewBox="0 0 24 24"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
            </button>
            <div class="wa-user-avatar">
              <svg class="ui-icon" viewBox="0 0 24 24"><path d="M12 2a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2 2 2 0 0 1-2-2V4a2 2 0 0 1 2-2z"></path><rect x="4" y="8" width="16" height="12" rx="2"></rect><circle cx="9" cy="13" r="1"></circle><circle cx="15" cy="13" r="1"></circle></svg>
            </div>
            <div class="wa-user-info">
              <div class="wa-user-name">
                Loko Assistant <span class="wa-verified">✓</span>
              </div>
              <div class="wa-status">AI Business Partner (Online)</div>
            </div>
          </div>
          <div style="color:#FFF;">
            <svg class="ui-icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="1"></circle><circle cx="12" cy="5" r="1"></circle><circle cx="12" cy="19" r="1"></circle></svg>
          </div>
        </div>

        <div class="wa-persona-bar">
          <button class="persona-chip active" id="chipPersonaOwner" onclick="switchWaPersona('owner')">Owner View</button>
          <button class="persona-chip" id="chipPersonaStaff" onclick="switchWaPersona('staff')">Kasir/Staff</button>
          <button class="persona-chip" id="chipPersonaCustomer" onclick="switchWaPersona('customer')">Pelanggan</button>
        </div>

        <div class="wa-messages-container" id="waMessagesStream">
          <!-- Injected via JS -->
        </div>

        <div class="wa-quick-replies" id="waQuickReplies">
          <!-- Injected via JS -->
        </div>

        <div class="wa-input-bar">
          <input type="text" class="wa-text-input" id="waCustomInput" placeholder="Ketik pertanyaan untuk AI..." onkeydown="if(event.key==='Enter') sendWaCustomMessage()">
          <button class="wa-send-btn" onclick="sendWaCustomMessage()">
            <svg class="ui-icon" viewBox="0 0 24 24"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
          </button>
        </div>
      </div>
    </div>

  </main>

  <!-- ========================================================================
       SHARED MODALS
       ======================================================================== -->

  <!-- Modal: Payment & Receipt -->
  <div class="modal-overlay" id="paymentModal">
    <div class="modal-card">
      <div class="modal-header">
        <span>Pembayaran Kasir</span>
        <button onclick="closeModal('paymentModal')">
          <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
        </button>
      </div>
      <div class="modal-body" id="paymentStepSelect">
        <div style="text-align:center; padding:10px 0;">
          <div style="font-size:12px; color:var(--text-muted);">Total Tagihan</div>
          <div class="tabular-nums" style="font-size:30px; font-weight:800; color:var(--primary);" id="payModalTotal">Rp0</div>
        </div>

        <div style="display:flex; gap:6px;">
          <button class="category-pill active" id="btnPayTabCash" onclick="selectPayMethod('cash', this)" style="flex:1;">Tunai</button>
          <button class="category-pill" id="btnPayTabQris" onclick="selectPayMethod('qris', this)" style="flex:1;">QRIS Dinamis</button>
          <button class="category-pill" id="btnPayTabCard" onclick="selectPayMethod('card', this)" style="flex:1;">Kartu / EDC</button>
        </div>

        <div id="paySectionCash" style="display:flex; flex-direction:column; gap:10px;">
          <label style="font-size:12px; font-weight:600;">Nominal Uang Diterima:</label>
          <div style="display:grid; grid-template-columns: repeat(3, 1fr); gap:8px;">
            <button class="btn-secondary" onclick="setCashAmount('exact')">Uang Pas</button>
            <button class="btn-secondary" onclick="setCashAmount(50000)">Rp50.000</button>
            <button class="btn-secondary" onclick="setCashAmount(100000)">Rp100.000</button>
          </div>
          <input type="number" id="inputCashReceived" style="padding:10px; border:1px solid var(--border-color); border-radius:var(--radius-sm); font-size:14px; font-weight:700;" placeholder="Nominal lain..." oninput="calcChange()">
          
          <div style="background:var(--surface-secondary); padding:10px; border-radius:var(--radius-sm); display:flex; justify-content:space-between; font-size:13px; border:1px solid var(--border-color);">
            <span>Kembalian:</span>
            <strong class="tabular-nums" id="labelChangeAmount" style="color:var(--success);">Rp0</strong>
          </div>
        </div>

        <div id="paySectionQris" style="display:none; flex-direction:column; align-items:center; gap:12px; padding:10px 0;">
          <div style="width:160px; height:160px; background:#000; border:4px solid #FFF; box-shadow:var(--shadow-md); display:flex; align-items:center; justify-content:center; color:#FFF; font-size:11px; text-align:center; padding:10px; border-radius:4px;">
            [QRIS DINAMIS DUMMY]<br>Scan BCA/GoPay/OVO
          </div>
          <span style="font-size:12px; color:var(--text-muted);">Menunggu konfirmasi pembayaran pelanggan...</span>
        </div>

        <div id="paySectionCard" style="display:none; flex-direction:column; gap:10px;">
          <label style="font-size:12px; font-weight:600;">Pilih Mesin EDC / Bank:</label>
          <select style="padding:10px; border:1px solid var(--border-color); border-radius:var(--radius-sm);">
            <option>EDC BCA (Debit / Kredit)</option>
            <option>EDC Mandiri</option>
          </select>
          <input type="text" placeholder="Nomor Referensi / Approval EDC" style="padding:10px; border:1px solid var(--border-color); border-radius:var(--radius-sm);">
        </div>
      </div>

      <div class="modal-body" id="paymentStepReceipt" style="display:none;">
        <div class="receipt-paper" id="receiptPaper">
          <!-- Injected via JS -->
        </div>
      </div>

      <div class="modal-footer" id="paymentFooterActions">
        <button class="btn-secondary" onclick="closeModal('paymentModal')">Batal</button>
        <button class="btn-pay" id="btnConfirmPay" onclick="executePayment()">
          Konfirmasi Bayar ✓
        </button>
      </div>
      <div class="modal-footer" id="receiptFooterActions" style="display:none;">
        <button class="btn-secondary" onclick="closeModal('paymentModal')">Tutup</button>
        <button class="btn-pay" onclick="simulatePrintReceipt()">Cetak Struk Thermal</button>
      </div>
    </div>
  </div>

  <!-- Modal: Table Selector -->
  <div class="modal-overlay" id="tableModal">
    <div class="modal-card">
      <div class="modal-header">
        <span>Denah Meja (Table Management)</span>
        <button onclick="closeModal('tableModal')">
          <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
        </button>
      </div>
      <div class="modal-body">
        <div style="display:grid; grid-template-columns: repeat(4, 1fr); gap:10px;" id="tableGrid">
          <!-- 12 Tables injected via JS -->
        </div>
      </div>
    </div>
  </div>

  <!-- Modal: Customer Selector -->
  <div class="modal-overlay" id="customerModal">
    <div class="modal-card">
      <div class="modal-header">
        <span>Pilih Pelanggan / Member</span>
        <button onclick="closeModal('customerModal')">
          <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
        </button>
      </div>
      <div class="modal-body">
        <div style="display:flex; flex-direction:column; gap:8px;">
          <div style="padding:12px; border:1px solid var(--primary); border-radius:var(--radius-sm); background:var(--primary-light); cursor:pointer;" onclick="selectCustomer('Rian Pratama', 14500)">
            <div style="font-weight:700; font-size:13px;">Rian Pratama (Member Gold)</div>
            <div style="font-size:12px; color:var(--primary);">14.500 Loko Points · Telp: 0812-3456-7890</div>
          </div>
          <div style="padding:12px; border:1px solid var(--border-color); border-radius:var(--radius-sm); cursor:pointer;" onclick="selectCustomer('Siti Sarah', 5200)">
            <div style="font-weight:700; font-size:13px;">Siti Sarah (Member Silver)</div>
            <div style="font-size:12px; color:var(--text-secondary);">5.200 Loko Points · Telp: 0857-1122-3344</div>
          </div>
          <div style="padding:12px; border:1px solid var(--border-color); border-radius:var(--radius-sm); cursor:pointer;" onclick="selectCustomer('Umum (Non-Member)', 0)">
            <div style="font-weight:700; font-size:13px;">Pelanggan Umum</div>
            <div style="font-size:12px; color:var(--text-muted);">Tanpa poin loyalitas</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal: Shift Summary -->
  <div class="modal-overlay" id="shiftModal">
    <div class="modal-card">
      <div class="modal-header">
        <span>Rekap Tutup Shift Kasir</span>
        <button onclick="closeModal('shiftModal')">
          <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
        </button>
      </div>
      <div class="modal-body" style="font-size:13px; display:flex; flex-direction:column; gap:10px;">
        <div style="display:flex; justify-content:space-between; border-bottom:1px solid var(--border-subtle); padding-bottom:6px;">
          <span>Kasir Aktif:</span>
          <strong>Budi Setiawan (Shift Pagi)</strong>
        </div>
        <div style="display:flex; justify-content:space-between; border-bottom:1px solid var(--border-subtle); padding-bottom:6px;">
          <span>Modal Awal Kas:</span>
          <strong class="tabular-nums">Rp500.000</strong>
        </div>
        <div style="display:flex; justify-content:space-between; border-bottom:1px solid var(--border-subtle); padding-bottom:6px;">
          <span>Total Penjualan Tunai:</span>
          <strong class="tabular-nums" id="shiftCashSales">Rp3.689.000</strong>
        </div>
        <div style="display:flex; justify-content:space-between; border-bottom:1px solid var(--border-subtle); padding-bottom:6px;">
          <span>Pengeluaran Kas Kecil:</span>
          <strong class="tabular-nums" style="color:var(--danger);">-Rp35.000</strong>
        </div>
        <div style="display:flex; justify-content:space-between; font-weight:700; font-size:14px; border-bottom:2px solid var(--border-color); padding-bottom:6px;">
          <span>Ekspektasi Uang Fisik Laci:</span>
          <strong class="tabular-nums" id="shiftExpectedCash" style="color:var(--primary);">Rp4.154.000</strong>
        </div>

        <div>
          <label style="font-weight:600; margin-bottom:4px; display:block;">Hitungan Uang Fisik Riil:</label>
          <input type="number" id="shiftActualCash" value="4154000" style="width:100%; padding:8px; border:1px solid var(--border-color); border-radius:var(--radius-sm); font-weight:700;" oninput="calcShiftDiff()">
        </div>

        <div style="background:var(--success-bg); color:var(--success); border:1px solid var(--success-border); padding:10px; border-radius:var(--radius-sm); font-weight:600;" id="shiftDiffStatus">
          ✓ Selisih: Rp0 (Kas Laci Cocok)
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn-secondary" onclick="closeModal('shiftModal')">Tutup</button>
        <button class="btn-pay" onclick="alert('Laporan shift berhasil dicetak.'); closeModal('shiftModal');">
          Cetak Rekap Shift
        </button>
      </div>
    </div>
  </div>

  <!-- Modal: Settings & Audit Log Light -->
  <div class="modal-overlay" id="settingsModal">
    <div class="modal-card">
      <div class="modal-header">
        <span>Pengaturan & Audit Trail</span>
        <button onclick="closeModal('settingsModal')">
          <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
        </button>
      </div>
      <div class="modal-body" style="font-size:13px; display:flex; flex-direction:column; gap:14px;">
        <div>
          <h4 style="font-size:13px; margin-bottom:6px;">Matriks Peran & Hak Akses (Role Matrix)</h4>
          <table class="data-table" style="font-size:12px;">
            <thead>
              <tr><th>Aksi Sistem</th><th>Owner</th><th>Manager</th><th>Kasir</th></tr>
            </thead>
            <tbody>
              <tr><td>Transaksi Kasir & Struk</td><td>✓</td><td>✓</td><td>✓</td></tr>
              <tr><td>Void & Refund Transaksi</td><td>✓</td><td>✓ (PIN)</td><td>✕ Butuh Izin</td></tr>
              <tr><td>Akses Laporan Laba Rugi</td><td>✓</td><td>✕</td><td>✕</td></tr>
              <tr><td>Ubah HPP & Resep</td><td>✓</td><td>✕</td><td>✕</td></tr>
            </tbody>
          </table>
        </div>

        <div>
          <h4 style="font-size:13px; margin-bottom:6px;">Audit Trail Log Terakhir</h4>
          <div style="background:var(--surface-secondary); border:1px solid var(--border-color); border-radius:var(--radius-sm); padding:8px; font-family:monospace; font-size:11px; max-height:110px; overflow-y:auto; line-height:1.4;">
            <div>[09:20:11] USER: Budi (Kasir) | Login Tablet Braga</div>
            <div>[09:25:44] USER: Budi | Buka Shift Kas Awal Rp500.000</div>
            <div>[09:34:12] USER: Budi | Transaksi #LK-0142 Tunai Rp74.000 Berhasil</div>
            <div>[09:34:13] SYSTEM | Auto-Journal #JRN-901 Dicatat Otomatis</div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn-secondary" onclick="closeModal('settingsModal')">Tutup</button>
      </div>
    </div>
  </div>

  <!-- Toast: Auto-Journal Wow Factor -->
  <div class="toast-accounting-wow" id="wowToast">
    <div style="color:#10B981;">
      <svg class="ui-icon ui-icon-lg" viewBox="0 0 24 24"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
    </div>
    <div>
      <div style="font-weight:700; font-size:13px;">Jurnal Otomatis Tercatat ✓</div>
      <div style="font-size:11px; color:#A3C2B4;" id="wowToastDetail">Dr Kas Rp... · Cr Penjualan Rp... · Dr HPP Rp...</div>
    </div>
    <button onclick="switchDevice('pos'); switchPosTab('accounting'); switchAccSubtab('journal'); hideWowToast();" style="background:#154734; border:1px solid rgba(255,255,255,0.2); color:#FFF; padding:5px 10px; border-radius:var(--radius-sm); font-size:11px; font-weight:600; margin-left:8px;">
      Lihat di Accounting ➔
    </button>
  </div>

  <!-- Pitching Script Guide Drawer -->
  <div class="pitch-guide-drawer" id="pitchGuideDrawer">
    <div class="guide-header">
      <div style="font-weight:700; font-size:14px;">Alur Pitching (7 Langkah PRD)</div>
      <button onclick="togglePitchGuide()" style="color:#FFF;">
        <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
      </button>
    </div>
    <div class="guide-steps-list">
      <div class="guide-step-card active" onclick="execPitchStep(1)">
        <div class="guide-step-title">1. Pesan di Web Order (Mobile)</div>
        <div class="guide-step-desc">Pindah ke Loko Order HP, pilih Aren Latte + Kantong, bayar simulasi QRIS.</div>
        <button class="tool-pill" style="margin-top:6px; color:#0D2E21;" onclick="execPitchStep(1)">▶ Jalankan Langkah 1</button>
      </div>

      <div class="guide-step-card" onclick="execPitchStep(2)">
        <div class="guide-step-title">2. Notif & Kartu Masuk di POS</div>
        <div class="guide-step-desc">Buka POS tab Pesanan. Pesanan baru dari web langsung muncul di kolom 'Baru'.</div>
        <button class="tool-pill" style="margin-top:6px; color:#0D2E21;" onclick="execPitchStep(2)">▶ Jalankan Langkah 2</button>
      </div>

      <div class="guide-step-card" onclick="execPitchStep(3)">
        <div class="guide-step-title">3. Barista Drag & Drop ke 'Siap'</div>
        <div class="guide-step-desc">Tarik kartu ke kolom 'Diproses' lalu 'Siap'. Di HP pelanggan muncul push notification.</div>
        <button class="tool-pill" style="margin-top:6px; color:#0D2E21;" onclick="execPitchStep(3)">▶ Jalankan Langkah 3</button>
      </div>

      <div class="guide-step-card" onclick="execPitchStep(4)">
        <div class="guide-step-title">4. Transaksi Kasir POS + Cetak Struk</div>
        <div class="guide-step-desc">Buka Kasir POS, pilih Meja 03, tambah Croissant + Cappuccino, bayar tunai & cetak struk.</div>
        <button class="tool-pill" style="margin-top:6px; color:#0D2E21;" onclick="execPitchStep(4)">▶ Jalankan Langkah 4</button>
      </div>

      <div class="guide-step-card" onclick="execPitchStep(5)">
        <div class="guide-step-title">5. Momen Wow: Jurnal Otomatis</div>
        <div class="guide-step-desc">Lihat toast jurnal muncul. Buka tab Accounting, jurnal Debit/Kredit terisi otomatis!</div>
        <button class="tool-pill" style="margin-top:6px; color:#0D2E21;" onclick="execPitchStep(5)">▶ Jalankan Langkah 5</button>
      </div>

      <div class="guide-step-card" onclick="execPitchStep(6)">
        <div class="guide-step-title">6. Laba Rugi, Neraca & Rekonsiliasi</div>
        <div class="guide-step-desc">Tunjukkan Laba Bersih naik instan, Neraca seimbang, dan klik 'Cocokkan' bank.</div>
        <button class="tool-pill" style="margin-top:6px; color:#0D2E21;" onclick="execPitchStep(6)">▶ Jalankan Langkah 6</button>
      </div>

      <div class="guide-step-card" onclick="execPitchStep(7)">
        <div class="guide-step-title">7. Chat WhatsApp AI Owner</div>
        <div class="guide-step-desc">Buka WA Assistant, klik 'Laporan Hari Ini'. AI menjawab dengan angka omzet riil sinkron.</div>
        <button class="tool-pill" style="margin-top:6px; color:#0D2E21;" onclick="execPitchStep(7)">▶ Jalankan Langkah 7</button>
      </div>
    </div>
  </div>

  <!-- ========================================================================
       SHARED STORE & ENGINE (VANILLA JS)
       ======================================================================== -->
  <script>
    /* ------------------------------------------------------------------------
       1. EMBEDDED ASSETS FROM ASSETS_BASE64.JSON
       ------------------------------------------------------------------------ */
    const ASSETS = __BASE64_ASSETS_PLACEHOLDER__;

    /* ------------------------------------------------------------------------
       2. MOCK DATA & SINGLE SOURCE OF TRUTH
       ------------------------------------------------------------------------ */
    const MOCK_DATA = {
      products: [
        { id: 1, name: "Kopi Susu Loko", category: "kopi", price: 22000, cost: 7700, photo: ASSETS.img4, stock: 84, isBest: true },
        { id: 2, name: "Aren Latte", category: "kopi", price: 26000, cost: 8900, photo: ASSETS.img4, stock: 65, isBest: true },
        { id: 3, name: "Caramel Macchiato", category: "kopi", price: 32000, cost: 13400, photo: ASSETS.img3, stock: 40, isBest: false },
        { id: 4, name: "Cafe Latte", category: "kopi", price: 27000, cost: 9200, photo: ASSETS.img2, stock: 52, isBest: false },
        { id: 5, name: "Cappuccino", category: "kopi", price: 27000, cost: 9200, photo: ASSETS.img2, stock: 48, isBest: false },
        { id: 6, name: "Americano Panas", category: "kopi", price: 20000, cost: 4200, photo: ASSETS.img1, stock: 95, isBest: false },
        { id: 7, name: "Iced Americano", category: "kopi", price: 22000, cost: 4500, photo: ASSETS.img5, stock: 78, isBest: false },
        { id: 8, name: "Butter Croissant", category: "makanan", price: 25000, cost: 11200, photo: ASSETS.img6, stock: 24, isBest: true },
        { id: 9, name: "Roti Pastry Coklat", category: "makanan", price: 25000, cost: 11500, photo: ASSETS.img7, stock: 30, isBest: false },
        { id: 10, name: "Almond Croissant", category: "makanan", price: 28000, cost: 12500, photo: ASSETS.img8, stock: 18, isBest: true },
        { id: 11, name: "Donat Glaze Artisan", category: "makanan", price: 18000, cost: 7000, photo: ASSETS.img9, stock: 42, isBest: false },
        { id: 12, name: "Donat Coklat", category: "makanan", price: 20000, cost: 8000, photo: ASSETS.img10, stock: 36, isBest: false },
        { id: 13, name: "Matcha Latte", category: "nonkopi", price: 30000, cost: 11000, photo: null, initials: "ML", stock: 38, isBest: true },
        { id: 14, name: "Chocolate Artisan", category: "nonkopi", price: 25000, cost: 9500, photo: null, initials: "CA", stock: 30, isBest: false },
        { id: 15, name: "Es Teh Lemon", category: "nonkopi", price: 15000, cost: 3500, photo: null, initials: "TL", stock: 110, isBest: false },
        { id: 16, name: "Kentang Goreng", category: "makanan", price: 20000, cost: 7000, photo: null, initials: "KG", stock: 45, isBest: false }
      ],
      tables: [
        { id: "01", status: "empty" }, { id: "02", status: "empty" },
        { id: "03", status: "occupied", order: "#LK-0139" }, { id: "04", status: "empty" },
        { id: "05", status: "billing", order: "#LK-0138" }, { id: "06", status: "empty" },
        { id: "07", status: "empty" }, { id: "08", status: "occupied", order: "#LK-0140" },
        { id: "09", status: "empty" }, { id: "10", status: "empty" },
        { id: "11", status: "empty" }, { id: "12", status: "empty" }
      ]
    };

    let STATE = {
      taxRate: 0.11, // PPN 11% default
      taxName: "PPN (11%)",
      currentOutlet: "braga",
      isAccountantMode: false,
      
      posCart: [],
      posOrderType: "Dine-in",
      selectedTable: "03",
      selectedCustomer: { name: "Umum", points: 0 },
      
      orders: [
        {
          id: "LK-0141",
          time: "09:32",
          source: "POS",
          type: "Dine-in",
          table: "03",
          items: [{ name: "Cappuccino", qty: 2, price: 27000 }, { name: "Butter Croissant", qty: 1, price: 25000 }],
          subtotal: 79000,
          tax: 8690,
          total: 87690,
          status: "proses"
        },
        {
          id: "LK-0140",
          time: "09:28",
          source: "Web Order",
          type: "Pickup",
          table: "-",
          customer: "Rian Pratama",
          items: [{ name: "Aren Latte", qty: 1, price: 26000 }],
          subtotal: 26000,
          tax: 2860,
          total: 28860,
          status: "siap"
        }
      ],

      todayOmzetBraga: 5940000,
      todayOmzetDago: 4600000,
      monthlyRevenue: 315000000,
      monthlyCogs: 110250000,
      monthlyExpenses: 139750000,
      totalCashBank: 189500000,

      journals: [
        {
          id: "JRN-899",
          time: "09:28",
          desc: "Penjualan Web Order #LK-0140 (QRIS Masuk ke Settlement)",
          account: "Dr Piutang QRIS Rp28.860 / Cr Penjualan Rp26.000 / Cr Hutang PPN Rp2.860 | Dr HPP Rp8.900 / Cr Persediaan Rp8.900",
          amount: 28860
        },
        {
          id: "JRN-898",
          time: "09:20",
          desc: "Penjualan Tunai Kasir Braga #LK-0139 (Dine-in)",
          account: "Dr Kas Laci Braga Rp74.000 / Cr Penjualan Rp66.666 / Cr Hutang PPN Rp7.334 | Dr HPP Rp23.000 / Cr Persediaan Rp23.000",
          amount: 74000
        },
        {
          id: "JRN-897",
          time: "09:05",
          desc: "Pembelian Es Kristal & Mint Tambahan (Petty Cash)",
          account: "Dr Beban Perlengkapan Dapur Rp35.000 / Cr Kas Laci Braga Rp35.000",
          amount: 35000
        }
      ],

      mobileCart: [
        { id: 2, name: "Aren Latte", price: 26000, cost: 8900, qty: 1, notes: "Less sugar, normal ice" }
      ],
      mobileService: "pickup",
      mobileOutlet: "Loko Coffee — Braga",
      lastCreatedOrderId: null,

      waPersona: "owner"
    };

    /* ------------------------------------------------------------------------
       3. INITIALIZATION
       ------------------------------------------------------------------------ */
    window.addEventListener("DOMContentLoaded", () => {
      initPosCatalog();
      renderPosCart();
      renderOrdersKanban();
      renderJournalsTable();
      renderReconciliation();
      renderMobileProducts();
      renderMobileCart();
      initWaChat();
      updateFinancialMetrics();
    });

    function switchDevice(device) {
      document.querySelectorAll(".switcher-btn").forEach(btn => btn.classList.remove("active"));
      document.querySelectorAll(".view-panel").forEach(panel => panel.classList.remove("active"));

      if (device === "pos") {
        document.getElementById("btnSwitchPos").classList.add("active");
        document.getElementById("viewPos").classList.add("active");
      } else if (device === "order") {
        document.getElementById("btnSwitchOrder").classList.add("active");
        document.getElementById("viewOrder").classList.add("active");
      } else if (device === "assistant") {
        document.getElementById("btnSwitchAssistant").classList.add("active");
        document.getElementById("viewAssistant").classList.add("active");
      }
    }

    function switchPosTab(tab) {
      document.querySelectorAll(".pos-tab-btn").forEach(b => b.classList.remove("active"));
      document.getElementById("posScreenKasir").style.display = "none";
      document.getElementById("posScreenPesanan").style.display = "none";
      document.getElementById("posScreenAccounting").style.display = "none";

      if (tab === "kasir") {
        document.getElementById("tabBtnKasir").classList.add("active");
        document.getElementById("posScreenKasir").style.display = "flex";
      } else if (tab === "pesanan") {
        document.getElementById("tabBtnPesanan").classList.add("active");
        document.getElementById("posScreenPesanan").style.display = "flex";
        renderOrdersKanban();
      } else if (tab === "accounting") {
        document.getElementById("tabBtnAccounting").classList.add("active");
        document.getElementById("posScreenAccounting").style.display = "flex";
        updateFinancialMetrics();
      }
    }

    function switchAccSubtab(sub, btnElement) {
      if (btnElement) {
        document.querySelectorAll(".acc-tab-btn").forEach(b => b.classList.remove("active"));
        btnElement.classList.add("active");
      }
      document.querySelectorAll(".acc-subpanel").forEach(p => p.classList.remove("active"));
      
      const targetMap = {
        dashboard: "accSubDashboard",
        journal: "accSubJournal",
        financials: "accSubFinancials",
        reconcile: "accSubReconcile",
        cogs: "accSubCogs",
        expenses: "accSubExpenses"
      };
      const target = document.getElementById(targetMap[sub]);
      if (target) target.classList.add("active");
    }

    function toggleAccMode() {
      STATE.isAccountantMode = !STATE.isAccountantMode;
      const toggleSwitch = document.getElementById("accModeSwitch");
      const label = document.getElementById("modeToggleLabel");
      const colAcc = document.querySelectorAll(".col-account-mode");

      if (STATE.isAccountantMode) {
        toggleSwitch.classList.add("active");
        label.innerText = "Mode Akuntan (COA & Dr/Cr)";
        colAcc.forEach(c => c.style.display = "table-cell");
      } else {
        toggleSwitch.classList.remove("active");
        label.innerText = "Tampilan Sederhana";
        colAcc.forEach(c => c.style.display = "none");
      }
      renderJournalsTable();
    }

    function toggleTaxMode() {
      if (STATE.taxRate === 0.11) {
        STATE.taxRate = 0.10;
        STATE.taxName = "PB1 Restoran (10%)";
        document.getElementById("taxModeLabel").innerText = "PB1 10%";
        document.getElementById("metricPajakSub").innerText = "PB1 10% (Pajak Restoran)";
        document.getElementById("taxLabelSummary").innerText = "PB1 Terutang (10%)";
      } else {
        STATE.taxRate = 0.11;
        STATE.taxName = "PPN (11%)";
        document.getElementById("taxModeLabel").innerText = "PPN 11%";
        document.getElementById("metricPajakSub").innerText = "PPN 11% + PPh 0.5%";
        document.getElementById("taxLabelSummary").innerText = "PPN Terutang (11%)";
      }
      document.getElementById("posTaxLabel").innerText = STATE.taxName;
      document.getElementById("chkTaxLabel").innerText = STATE.taxName;
      renderPosCart();
      calcMobileCartTotal();
      updateFinancialMetrics();
    }

    /* ------------------------------------------------------------------------
       4. KASIR CATALOG & CART
       ------------------------------------------------------------------------ */
    function initPosCatalog() {
      renderProductsGrid(MOCK_DATA.products);
    }

    function renderProductsGrid(products) {
      const grid = document.getElementById("productGrid");
      grid.innerHTML = "";
      products.forEach(p => {
        const card = document.createElement("div");
        card.className = "product-card";
        card.onclick = () => addProductToPosCart(p);

        const thumbHtml = p.photo 
          ? `<img src="${p.photo}" class="product-thumb-img" alt="${p.name}">`
          : `<div class="product-initials-fallback">${p.initials || "LK"}</div>`;

        card.innerHTML = `
          <div class="product-thumb-wrap">
            ${thumbHtml}
            <span class="product-badge-stock tabular-nums">${p.stock}</span>
          </div>
          <div class="product-card-body">
            <div class="product-title">${p.name}</div>
            <div class="product-price tabular-nums">Rp${p.price.toLocaleString("id-ID")}</div>
          </div>
        `;
        grid.appendChild(card);
      });
    }

    function filterCategory(cat, btn) {
      document.querySelectorAll(".category-pill").forEach(p => p.classList.remove("active"));
      if (btn) btn.classList.add("active");
      const filtered = (cat === "all") ? MOCK_DATA.products : MOCK_DATA.products.filter(p => p.category === cat);
      renderProductsGrid(filtered);
    }

    function filterCatalog() {
      const query = document.getElementById("catalogSearchInput").value.toLowerCase();
      const filtered = MOCK_DATA.products.filter(p => p.name.toLowerCase().includes(query));
      renderProductsGrid(filtered);
    }

    function addProductToPosCart(prod) {
      const existing = STATE.posCart.find(i => i.id === prod.id);
      if (existing) {
        existing.qty++;
      } else {
        STATE.posCart.push({
          id: prod.id,
          name: prod.name,
          price: prod.price,
          cost: prod.cost,
          qty: 1,
          notes: "Normal ice/sugar"
        });
      }
      renderPosCart();
    }

    function updatePosQty(id, delta) {
      const item = STATE.posCart.find(i => i.id === id);
      if (!item) return;
      item.qty += delta;
      if (item.qty <= 0) {
        STATE.posCart = STATE.posCart.filter(i => i.id !== id);
      }
      renderPosCart();
    }

    function renderPosCart() {
      const list = document.getElementById("posCartList");
      list.innerHTML = "";

      if (STATE.posCart.length === 0) {
        list.innerHTML = `
          <div style="text-align:center; padding:50px 10px; color:var(--text-muted); font-size:13px;">
            Belum ada item di keranjang kasir.<br>Pilih menu di sisi kiri untuk memulai.
          </div>
        `;
      } else {
        STATE.posCart.forEach(item => {
          const div = document.createElement("div");
          div.className = "cart-item";
          div.innerHTML = `
            <div class="cart-item-info">
              <div class="cart-item-name">${item.name}</div>
              <div class="cart-item-notes">${item.notes}</div>
              <div class="cart-item-price tabular-nums">Rp${(item.price * item.qty).toLocaleString("id-ID")}</div>
            </div>
            <div class="cart-qty-ctrl">
              <button class="qty-btn" onclick="updatePosQty(${item.id}, -1)">-</button>
              <span class="tabular-nums" style="font-weight:700; font-size:13px; min-width:18px; text-align:center;">${item.qty}</span>
              <button class="qty-btn" onclick="updatePosQty(${item.id}, 1)">+</button>
            </div>
          `;
          list.appendChild(div);
        });
      }

      const subtotal = STATE.posCart.reduce((sum, i) => sum + (i.price * i.qty), 0);
      const discount = 0;
      const tax = Math.round(subtotal * STATE.taxRate);
      const grandTotal = subtotal - discount + tax;

      document.getElementById("posSubtotal").innerText = `Rp${subtotal.toLocaleString("id-ID")}`;
      document.getElementById("posDiscount").innerText = `-Rp${discount.toLocaleString("id-ID")}`;
      document.getElementById("posTax").innerText = `Rp${tax.toLocaleString("id-ID")}`;
      document.getElementById("posGrandTotal").innerText = `Rp${grandTotal.toLocaleString("id-ID")}`;
    }

    function setOrderType(type, btn) {
      STATE.posOrderType = type;
      document.querySelectorAll(".order-type-btn").forEach(b => b.classList.remove("active"));
      if (btn) btn.classList.add("active");
    }

    function holdCurrentCart() {
      if (STATE.posCart.length === 0) {
        alert("Keranjang kosong, tidak ada pesanan untuk disimpan.");
        return;
      }
      alert(`Pesanan Meja ${STATE.selectedTable} berhasil disimpan.`);
      STATE.posCart = [];
      renderPosCart();
    }

    /* ------------------------------------------------------------------------
       5. PAYMENT & RECEIPT
       ------------------------------------------------------------------------ */
    let selectedPayMethodType = "cash";

    function openPaymentModal() {
      if (STATE.posCart.length === 0) {
        alert("Pilih setidaknya 1 produk sebelum pembayaran.");
        return;
      }
      const subtotal = STATE.posCart.reduce((sum, i) => sum + (i.price * i.qty), 0);
      const tax = Math.round(subtotal * STATE.taxRate);
      const total = subtotal + tax;

      document.getElementById("payModalTotal").innerText = `Rp${total.toLocaleString("id-ID")}`;
      document.getElementById("inputCashReceived").value = total;
      document.getElementById("labelChangeAmount").innerText = "Rp0";

      document.getElementById("paymentStepSelect").style.display = "block";
      document.getElementById("paymentStepReceipt").style.display = "none";
      document.getElementById("paymentFooterActions").style.display = "flex";
      document.getElementById("receiptFooterActions").style.display = "none";

      document.getElementById("paymentModal").classList.add("active");
    }

    function selectPayMethod(method, btn) {
      selectedPayMethodType = method;
      document.querySelectorAll("#paymentStepSelect .category-pill").forEach(p => p.classList.remove("active"));
      if (btn) btn.classList.add("active");

      document.getElementById("paySectionCash").style.display = method === "cash" ? "flex" : "none";
      document.getElementById("paySectionQris").style.display = method === "qris" ? "flex" : "none";
      document.getElementById("paySectionCard").style.display = method === "card" ? "flex" : "none";
    }

    function setCashAmount(amt) {
      const subtotal = STATE.posCart.reduce((sum, i) => sum + (i.price * i.qty), 0);
      const tax = Math.round(subtotal * STATE.taxRate);
      const total = subtotal + tax;

      if (amt === "exact") {
        document.getElementById("inputCashReceived").value = total;
      } else {
        document.getElementById("inputCashReceived").value = amt;
      }
      calcChange();
    }

    function calcChange() {
      const subtotal = STATE.posCart.reduce((sum, i) => sum + (i.price * i.qty), 0);
      const tax = Math.round(subtotal * STATE.taxRate);
      const total = subtotal + tax;
      const rec = parseInt(document.getElementById("inputCashReceived").value || 0, 10);
      const change = Math.max(0, rec - total);
      document.getElementById("labelChangeAmount").innerText = `Rp${change.toLocaleString("id-ID")}`;
    }

    function executePayment() {
      const subtotal = STATE.posCart.reduce((sum, i) => sum + (i.price * i.qty), 0);
      const cogs = STATE.posCart.reduce((sum, i) => sum + (i.cost * i.qty), 0);
      const tax = Math.round(subtotal * STATE.taxRate);
      const total = subtotal + tax;
      const orderId = `LK-0${Math.floor(100 + Math.random() * 900)}`;

      STATE.orders.unshift({
        id: orderId,
        time: new Date().toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" }),
        source: "POS",
        type: STATE.posOrderType,
        table: STATE.selectedTable,
        items: [...STATE.posCart],
        subtotal: subtotal,
        tax: tax,
        total: total,
        status: "proses"
      });

      STATE.todayOmzetBraga += subtotal;
      STATE.monthlyRevenue += subtotal;
      STATE.monthlyCogs += cogs;
      STATE.totalCashBank += total;

      const accountDr = selectedPayMethodType === "cash" ? "Kas Laci Braga" : (selectedPayMethodType === "qris" ? "Piutang QRIS" : "Bank BCA");
      STATE.journals.unshift({
        id: `JRN-${Math.floor(900 + Math.random() * 99)}`,
        time: new Date().toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" }),
        desc: `Penjualan ${STATE.posOrderType} ${orderId} (${selectedPayMethodType.toUpperCase()})`,
        account: `Dr ${accountDr} Rp${total.toLocaleString("id-ID")} / Cr Penjualan Rp${subtotal.toLocaleString("id-ID")} / Cr Hutang Pajak Rp${tax.toLocaleString("id-ID")} | Dr HPP Rp${cogs.toLocaleString("id-ID")} / Cr Persediaan Rp${cogs.toLocaleString("id-ID")}`,
        amount: total
      });

      showWowToast(`Dr ${accountDr} Rp${total.toLocaleString("id-ID")} · Cr Penjualan Rp${subtotal.toLocaleString("id-ID")} · HPP Rp${cogs.toLocaleString("id-ID")}`);

      renderThermalReceipt(orderId, subtotal, tax, total);

      document.getElementById("paymentStepSelect").style.display = "none";
      document.getElementById("paymentStepReceipt").style.display = "block";
      document.getElementById("paymentFooterActions").style.display = "none";
      document.getElementById("receiptFooterActions").style.display = "flex";

      STATE.posCart = [];
      renderPosCart();
      renderOrdersKanban();
      renderJournalsTable();
      updateFinancialMetrics();
    }

    function renderThermalReceipt(orderId, subtotal, tax, total) {
      const now = new Date();
      const timeStr = now.toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" });

      const paper = document.getElementById("receiptPaper");
      paper.innerHTML = `
        <div style="text-align:center;">
          <h3 style="margin:0; font-size:14px; font-weight:bold;">LOKO COFFEE — BRAGA</h3>
          <div>Jl. Braga No. 45, Bandung</div>
          <div>NPWP: 01.345.678.9-428.000</div>
          <div>--------------------------------</div>
        </div>
        <div style="display:flex; justify-content:space-between;">
          <span>No: ${orderId}</span>
          <span>${timeStr}</span>
        </div>
        <div style="display:flex; justify-content:space-between;">
          <span>Kasir: Budi S.</span>
          <span>Meja: ${STATE.selectedTable} (${STATE.posOrderType})</span>
        </div>
        <div>--------------------------------</div>
        <div>
          ${STATE.orders[0].items.map(i => `
            <div style="display:flex; justify-content:space-between;">
              <span>${i.qty}x ${i.name}</span>
              <span class="tabular-nums">Rp${(i.price * i.qty).toLocaleString("id-ID")}</span>
            </div>
          `).join("")}
        </div>
        <div>--------------------------------</div>
        <div style="display:flex; justify-content:space-between;">
          <span>Subtotal</span>
          <span class="tabular-nums">Rp${subtotal.toLocaleString("id-ID")}</span>
        </div>
        <div style="display:flex; justify-content:space-between;">
          <span>${STATE.taxName}</span>
          <span class="tabular-nums">Rp${tax.toLocaleString("id-ID")}</span>
        </div>
        <div style="display:flex; justify-content:space-between; font-weight:bold; margin-top:2px;">
          <span>TOTAL</span>
          <span class="tabular-nums">Rp${total.toLocaleString("id-ID")}</span>
        </div>
        <div style="display:flex; justify-content:space-between;">
          <span>Metode: ${selectedPayMethodType.toUpperCase()}</span>
          <span>Lunas ✓</span>
        </div>
        <div>--------------------------------</div>
        <div style="text-align:center; font-size:11px;">
          Terima kasih atas kunjungan Anda!<br>
          Instagram: @lokocoffee.id<br>
          [Auto-Journaled to Loko Accounting]
        </div>
      `;
    }

    function simulatePrintReceipt() {
      alert("Mencetak struk thermal ke printer kasir... Berhasil!");
      closeModal("paymentModal");
    }

    function showWowToast(detailText) {
      const toast = document.getElementById("wowToast");
      document.getElementById("wowToastDetail").innerText = detailText;
      toast.classList.add("show");
      setTimeout(() => {
        hideWowToast();
      }, 7000);
    }

    function hideWowToast() {
      document.getElementById("wowToast").classList.remove("show");
    }

    /* ------------------------------------------------------------------------
       6. KANBAN WITH NATIVE HTML5 DRAG & DROP
       ------------------------------------------------------------------------ */
    let draggedOrderId = null;

    function handleDragStart(e, orderId) {
      draggedOrderId = orderId;
      e.dataTransfer.setData("text/plain", orderId);
      e.dataTransfer.effectAllowed = "move";
      setTimeout(() => {
        const card = document.getElementById(`orderCard-${orderId}`);
        if (card) card.classList.add("dragging");
      }, 0);
    }

    function handleDragEnd(e) {
      document.querySelectorAll(".order-card").forEach(c => c.classList.remove("dragging"));
      document.querySelectorAll(".kanban-col").forEach(c => c.classList.remove("drag-over"));
      draggedOrderId = null;
    }

    function allowDrop(e) {
      e.preventDefault();
      e.dataTransfer.dropEffect = "move";
      const col = e.currentTarget;
      if (!col.classList.contains("drag-over")) {
        col.classList.add("drag-over");
      }
    }

    function dragLeave(e) {
      e.currentTarget.classList.remove("drag-over");
    }

    function drop(e, newStatus) {
      e.preventDefault();
      e.currentTarget.classList.remove("drag-over");
      const orderId = e.dataTransfer.getData("text/plain") || draggedOrderId;
      if (orderId) {
        advanceOrderStatus(orderId, newStatus);
      }
    }

    function renderOrdersKanban() {
      const colBaru = document.getElementById("colBaruCards");
      const colProses = document.getElementById("colProsesCards");
      const colSiap = document.getElementById("colSiapCards");
      const colSelesai = document.getElementById("colSelesaiCards");

      colBaru.innerHTML = "";
      colProses.innerHTML = "";
      colSiap.innerHTML = "";
      colSelesai.innerHTML = "";

      let countBaru = 0;
      let countProses = 0;
      let countSiap = 0;

      STATE.orders.forEach(ord => {
        const card = document.createElement("div");
        card.className = `order-card ${ord.isNew ? "highlight-new" : ""}`;
        card.id = `orderCard-${ord.id}`;
        card.draggable = true;
        card.ondragstart = (e) => handleDragStart(e, ord.id);
        card.ondragend = (e) => handleDragEnd(e);
        
        const isWeb = ord.source === "Web Order";
        const badgeClass = isWeb ? "badge-web" : "badge-pos";
        
        card.innerHTML = `
          <div class="order-card-top">
            <span class="order-badge-src ${badgeClass}">${ord.source}</span>
            <span class="tabular-nums" style="font-size:11px; font-weight:600; color:var(--text-muted);">${ord.time}</span>
          </div>
          <div class="order-id-label">
            ${ord.id} · ${ord.type} ${ord.table !== "-" ? `(Meja ${ord.table})` : ""}
          </div>
          <div class="order-items-preview">
            ${ord.items.map(i => `${i.qty}x ${i.name}`).join(", ")}
          </div>
          <div class="order-card-meta">
            <span>Total: <strong class="tabular-nums">Rp${ord.total.toLocaleString("id-ID")}</strong></span>
            <span style="color:var(--success); font-weight:600;">Lunas</span>
          </div>
          <div class="order-card-actions" id="actions-${ord.id}"></div>
        `;

        const actContainer = card.querySelector(`#actions-${ord.id}`);

        if (ord.status === "baru") {
          countBaru++;
          actContainer.innerHTML = `
            <button class="btn-card-action btn-action-primary" onclick="advanceOrderStatus('${ord.id}', 'proses')">
              Proses Barista ➔
            </button>
          `;
          colBaru.appendChild(card);
        } else if (ord.status === "proses") {
          countProses++;
          actContainer.innerHTML = `
            <button class="btn-card-action btn-action-primary" onclick="advanceOrderStatus('${ord.id}', 'siap')">
              Siap Saji ✓
            </button>
          `;
          colProses.appendChild(card);
        } else if (ord.status === "siap") {
          countSiap++;
          actContainer.innerHTML = `
            <button class="btn-card-action btn-action-primary" onclick="advanceOrderStatus('${ord.id}', 'selesai')">
              Selesaikan
            </button>
          `;
          colSiap.appendChild(card);
        } else {
          actContainer.innerHTML = `<span style="font-size:11px; color:var(--text-muted);">Selesai di counter</span>`;
          colSelesai.appendChild(card);
        }
      });

      document.getElementById("countColBaru").innerText = countBaru;
      document.getElementById("countColProses").innerText = countProses;
      document.getElementById("countColSiap").innerText = countSiap;
      document.getElementById("posOrderCount").innerText = countBaru + countProses;
    }

    function advanceOrderStatus(orderId, newStatus) {
      const order = STATE.orders.find(o => o.id === orderId);
      if (!order) return;
      order.status = newStatus;
      delete order.isNew;

      if (order.source === "Web Order") {
        if (newStatus === "proses") {
          showMobilePush("Barista Sedang Meracik", "Pesananmu sedang disiapkan di counter Loko Braga.");
          updateMobileTrackingStep(2);
        } else if (newStatus === "siap") {
          showMobilePush("Pesananmu Siap!", "Silakan ambil di area Pickup Counter Loko Braga.");
          updateMobileTrackingStep(3);
        } else if (newStatus === "selesai") {
          showMobilePush("Pesanan Selesai", "+15 Loko Points telah ditambahkan ke akunmu.");
          updateMobileTrackingStep(4);
        }
      }

      renderOrdersKanban();
    }

    function filterOrderType(type, btn) {
      document.querySelectorAll(".pesanan-filter-btn").forEach(b => b.classList.remove("active"));
      if (btn) btn.classList.add("active");
    }

    /* ------------------------------------------------------------------------
       7. ACCOUNTING ENGINE
       ------------------------------------------------------------------------ */
    function renderJournalsTable() {
      const tbody = document.getElementById("journalTableBody");
      tbody.innerHTML = "";

      STATE.journals.forEach(j => {
        const tr = document.createElement("tr");
        tr.innerHTML = `
          <td><strong>${j.id}</strong><div style="font-size:11px; color:var(--text-muted);">${j.time}</div></td>
          <td>${j.desc}</td>
          <td class="col-account-mode" style="${STATE.isAccountantMode ? "display:table-cell;" : "display:none;"} font-family:monospace; font-size:11px; color:var(--primary);">
            ${j.account}
          </td>
          <td class="tabular-nums"><strong>Rp${j.amount.toLocaleString("id-ID")}</strong></td>
          <td><span class="reconcile-match-badge badge-matched">Tervalidasi</span></td>
        `;
        tbody.appendChild(tr);
      });
    }

    function updateFinancialMetrics() {
      const grossProfit = STATE.monthlyRevenue - STATE.monthlyCogs;
      const netProfit = grossProfit - STATE.monthlyExpenses;
      const todayTotal = STATE.todayOmzetBraga + STATE.todayOmzetDago;
      const todayHpp = Math.round(todayTotal * 0.35);
      const todayGross = todayTotal - todayHpp;

      document.getElementById("metricOmzetHariIni").innerText = `Rp${STATE.todayOmzetBraga.toLocaleString("id-ID")}`;
      document.getElementById("metricHppHariIni").innerText = `Rp${todayHpp.toLocaleString("id-ID")}`;
      document.getElementById("metricLabaKotorHariIni").innerText = `Rp${todayGross.toLocaleString("id-ID")}`;
      document.getElementById("metricKasTotal").innerText = `Rp${STATE.totalCashBank.toLocaleString("id-ID")}`;
      document.getElementById("metricLabaBersihBulanIni").innerText = `Rp${netProfit.toLocaleString("id-ID")}`;

      const taxDue = Math.round(STATE.monthlyRevenue * STATE.taxRate);
      document.getElementById("metricHutangPajak").innerText = `Rp${taxDue.toLocaleString("id-ID")}`;
      document.getElementById("taxValSummary").innerText = `Rp${taxDue.toLocaleString("id-ID")}`;

      document.getElementById("plOmzet").innerText = `Rp${STATE.monthlyRevenue.toLocaleString("id-ID")}`;
      document.getElementById("plTotalRevenue").innerText = `Rp${STATE.monthlyRevenue.toLocaleString("id-ID")}`;
      document.getElementById("plHpp").innerText = `(Rp${STATE.monthlyCogs.toLocaleString("id-ID")})`;
      document.getElementById("plGrossProfit").innerText = `Rp${grossProfit.toLocaleString("id-ID")}`;
      document.getElementById("plNetProfit").innerText = `Rp${netProfit.toLocaleString("id-ID")}`;

      const totalAssets = STATE.totalCashBank + 18500000 + 42000000 + 180000000;
      document.getElementById("bsKas").innerText = `Rp${STATE.totalCashBank.toLocaleString("id-ID")}`;
      document.getElementById("bsTotalAssets").innerText = `Rp${totalAssets.toLocaleString("id-ID")}`;
      document.getElementById("bsTotalLiabEquity").innerText = `Rp${totalAssets.toLocaleString("id-ID")}`;
      document.getElementById("bsRetainedEarnings").innerText = `Rp${netProfit.toLocaleString("id-ID")}`;

      document.getElementById("omzetBragaBar").innerText = `Rp${STATE.todayOmzetBraga.toLocaleString("id-ID")}`;
      document.getElementById("omzetDagoBar").innerText = `Rp${STATE.todayOmzetDago.toLocaleString("id-ID")}`;
    }

    function renderReconciliation() {
      const lokoBody = document.getElementById("reconcileLokoBody");
      const bankBody = document.getElementById("reconcileBankBody");

      lokoBody.innerHTML = `
        <tr><td>29/09</td><td>Settlement QRIS Braga</td><td class="tabular-nums">Rp4.743.000</td><td><span class="reconcile-match-badge badge-matched">Cocok ✓</span></td></tr>
        <tr><td>29/09</td><td>Setoran Tunai Shift Pagi</td><td class="tabular-nums">Rp3.650.000</td><td><span class="reconcile-match-badge badge-matched">Cocok ✓</span></td></tr>
        <tr><td>29/09</td><td>Pembelian Biji Kopi Arabika</td><td class="tabular-nums">(Rp2.500.000)</td><td><span class="reconcile-match-badge badge-matched">Cocok ✓</span></td></tr>
        <tr><td>29/09</td><td>Settlement Web Order</td><td class="tabular-nums">Rp527.000</td><td><span class="reconcile-match-badge badge-diff">Belum Klir</span></td></tr>
      `;

      bankBody.innerHTML = `
        <tr><td>29/09</td><td>CR QRIS MERCHANT BCA</td><td class="tabular-nums">Rp4.743.000</td><td><button class="tool-pill" style="font-size:11px;">Tersinkron</button></td></tr>
        <tr><td>29/09</td><td>CR SETORAN TUNAI CDM</td><td class="tabular-nums">Rp3.650.000</td><td><button class="tool-pill" style="font-size:11px;">Tersinkron</button></td></tr>
        <tr><td>29/09</td><td>DB TRF SUPPLIER ROASTERY</td><td class="tabular-nums">Rp2.500.000</td><td><button class="tool-pill" style="font-size:11px;">Tersinkron</button></td></tr>
        <tr><td>29/09</td><td>CR VA ONLINE PAYMENT</td><td class="tabular-nums">Rp527.000</td><td><button class="btn-pay" style="padding:3px 8px; font-size:10px;" onclick="alert('Transaksi berhasil dicocokkan!')">Cocokkan</button></td></tr>
      `;
    }

    function runAutoReconcile() {
      alert("Rekonsiliasi Otomatis Berhasil! Seluruh 4 mutasi bank telah terverifikasi cocok.");
      renderReconciliation();
    }

    function submitExpense() {
      const cat = document.getElementById("expenseCategory").value;
      const amt = parseInt(document.getElementById("expenseAmount").value || 0, 10);
      if (amt <= 0) {
        alert("Masukkan nominal biaya.");
        return;
      }

      STATE.monthlyExpenses += amt;
      STATE.totalCashBank -= amt;

      STATE.journals.unshift({
        id: `JRN-${Math.floor(900 + Math.random() * 99)}`,
        time: new Date().toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" }),
        desc: `Biaya Kas Kecil: ${cat}`,
        account: `Dr Beban Operasional Rp${amt.toLocaleString("id-ID")} / Cr Kas Laci Rp${amt.toLocaleString("id-ID")}`,
        amount: amt
      });

      alert(`Biaya ${cat} sebesar Rp${amt.toLocaleString("id-ID")} berhasil dicatat.`);
      document.getElementById("expenseAmount").value = "";
      renderJournalsTable();
      updateFinancialMetrics();
    }

    function simulateExportCSV(filename) {
      const csvContent = "data:text/csv;charset=utf-8,Waktu,No Transaksi,Keterangan,Nominal,Status\n" +
        STATE.journals.map(j => `"${j.time}","${j.id}","${j.desc}","${j.amount}","Valid"`).join("\n");
      const encodedUri = encodeURI(csvContent);
      const link = document.createElement("a");
      link.setAttribute("href", encodedUri);
      link.setAttribute("download", filename);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }

    /* ------------------------------------------------------------------------
       8. LOKO ORDER (KOPI KENANGAN FLOW)
       ------------------------------------------------------------------------ */
    function renderMobileProducts() {
      const container = document.getElementById("orderProductList");
      container.innerHTML = "";

      MOCK_DATA.products.forEach(p => {
        const card = document.createElement("div");
        card.className = "order-product-card";
        card.onclick = () => addProductToMobileCart(p);

        const thumbHtml = p.photo
          ? `<img src="${p.photo}" alt="${p.name}">`
          : `<div style="font-weight:700; color:var(--primary); font-size:16px;">${p.initials || "LK"}</div>`;

        card.innerHTML = `
          <div class="order-prod-thumb">${thumbHtml}</div>
          <div class="order-prod-details">
            <div>
              <div class="order-prod-name">${p.name} ${p.isBest ? "★" : ""}</div>
              <div class="order-prod-desc">${p.category === "kopi" ? "Espresso blend spesial + susu segar" : "Bahan artisan pilihan"}</div>
            </div>
            <div style="display:flex; justify-content:space-between; align-items:center;">
              <span class="order-prod-price tabular-nums">Rp${p.price.toLocaleString("id-ID")}</span>
              <button class="category-pill active" style="padding:3px 10px; font-size:11px;">+ Tambah</button>
            </div>
          </div>
        `;
        container.appendChild(card);
      });
    }

    function filterMobileCategory(cat, btn) {
      document.querySelectorAll(".order-cat-item").forEach(b => b.classList.remove("active"));
      if (btn) btn.classList.add("active");
      const container = document.getElementById("orderProductList");
      container.innerHTML = "";
      const filtered = (cat === "all") ? MOCK_DATA.products : MOCK_DATA.products.filter(p => p.category === cat);
      filtered.forEach(p => {
        const card = document.createElement("div");
        card.className = "order-product-card";
        card.onclick = () => addProductToMobileCart(p);

        const thumbHtml = p.photo
          ? `<img src="${p.photo}" alt="${p.name}">`
          : `<div style="font-weight:700; color:var(--primary); font-size:16px;">${p.initials || "LK"}</div>`;

        card.innerHTML = `
          <div class="order-prod-thumb">${thumbHtml}</div>
          <div class="order-prod-details">
            <div>
              <div class="order-prod-name">${p.name} ${p.isBest ? "★" : ""}</div>
              <div class="order-prod-desc">${p.category === "kopi" ? "Espresso blend spesial + susu segar" : "Bahan artisan pilihan"}</div>
            </div>
            <div style="display:flex; justify-content:space-between; align-items:center;">
              <span class="order-prod-price tabular-nums">Rp${p.price.toLocaleString("id-ID")}</span>
              <button class="category-pill active" style="padding:3px 10px; font-size:11px;">+ Tambah</button>
            </div>
          </div>
        `;
        container.appendChild(card);
      });
    }

    function addProductToMobileCart(p) {
      const item = STATE.mobileCart.find(i => i.id === p.id);
      if (item) {
        item.qty++;
      } else {
        STATE.mobileCart.push({
          id: p.id,
          name: p.name,
          price: p.price,
          cost: p.cost,
          qty: 1,
          notes: "Normal sugar, normal ice"
        });
      }
      renderMobileCart();
    }

    function renderMobileCart() {
      const cartBar = document.getElementById("orderFloatingCart");
      const totalQty = STATE.mobileCart.reduce((sum, i) => sum + i.qty, 0);
      const subtotal = STATE.mobileCart.reduce((sum, i) => sum + (i.price * i.qty), 0);

      if (totalQty > 0) {
        cartBar.style.display = "flex";
        document.getElementById("orderCartCount").innerText = totalQty;
        document.getElementById("orderCartTotal").innerText = `Rp${subtotal.toLocaleString("id-ID")}`;
      } else {
        cartBar.style.display = "none";
      }
    }

    function setMobileService(svc, btn) {
      STATE.mobileService = svc;
      document.querySelectorAll(".service-btn").forEach(b => b.classList.remove("active"));
      if (btn) btn.classList.add("active");
    }

    function toggleMobileOutlet() {
      if (STATE.mobileOutlet.includes("Braga")) {
        STATE.mobileOutlet = "Loko Coffee — Dago";
        document.getElementById("orderOutletTitle").innerText = "Loko Coffee — Dago";
        document.getElementById("orderOutletDist").innerText = "Jl. Ir. H. Juanda No. 102 · 3.4 km dari lokasimu";
      } else {
        STATE.mobileOutlet = "Loko Coffee — Braga";
        document.getElementById("orderOutletTitle").innerText = "Loko Coffee — Braga";
        document.getElementById("orderOutletDist").innerText = "Jl. Braga No. 45 · 1.2 km dari lokasimu";
      }
    }

    function openOrderCheckout() {
      const itemsContainer = document.getElementById("orderCheckoutItems");
      itemsContainer.innerHTML = "";

      STATE.mobileCart.forEach(i => {
        const row = document.createElement("div");
        row.style.cssText = "display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px;";
        row.innerHTML = `
          <div>
            <strong>${i.qty}x ${i.name}</strong>
            <div style="font-size:11px; color:var(--text-muted);">${i.notes}</div>
          </div>
          <span class="tabular-nums">Rp${(i.price * i.qty).toLocaleString("id-ID")}</span>
        `;
        itemsContainer.appendChild(row);
      });

      calcMobileCartTotal();
      document.getElementById("orderSubpageCheckout").classList.add("active");
    }

    function calcMobileCartTotal() {
      const subtotal = STATE.mobileCart.reduce((sum, i) => sum + (i.price * i.qty), 0);
      const usePoints = document.getElementById("chkUsePoints").checked;
      const addBag = document.getElementById("chkAddBag").checked;

      const discountPromo = Math.round(subtotal * 0.10);
      const pointsCut = usePoints ? 5000 : 0;
      const bagFee = addBag ? 1000 : 0;

      const taxableBase = Math.max(0, subtotal - discountPromo - pointsCut);
      const tax = Math.round(taxableBase * STATE.taxRate);
      const grandTotal = taxableBase + tax + bagFee;

      document.getElementById("chkSubtotal").innerText = `Rp${subtotal.toLocaleString("id-ID")}`;
      document.getElementById("chkDiscount").innerText = `-Rp${(discountPromo + pointsCut).toLocaleString("id-ID")}`;
      document.getElementById("chkTax").innerText = `Rp${tax.toLocaleString("id-ID")}`;
      document.getElementById("chkGrandTotal").innerText = `Rp${grandTotal.toLocaleString("id-ID")}`;
    }

    function submitMobileOrder() {
      const subtotal = STATE.mobileCart.reduce((sum, i) => sum + (i.price * i.qty), 0);
      const cogs = STATE.mobileCart.reduce((sum, i) => sum + (i.cost * i.qty), 0);
      const usePoints = document.getElementById("chkUsePoints").checked;
      const addBag = document.getElementById("chkAddBag").checked;

      const discountPromo = Math.round(subtotal * 0.10);
      const pointsCut = usePoints ? 5000 : 0;
      const bagFee = addBag ? 1000 : 0;
      const taxableBase = Math.max(0, subtotal - discountPromo - pointsCut);
      const tax = Math.round(taxableBase * STATE.taxRate);
      const grandTotal = taxableBase + tax + bagFee;

      const orderId = `LK-0${Math.floor(100 + Math.random() * 900)}`;
      STATE.lastCreatedOrderId = orderId;

      STATE.orders.unshift({
        id: orderId,
        time: new Date().toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" }),
        source: "Web Order",
        type: STATE.mobileService === "pickup" ? "Pickup" : (STATE.mobileService === "delivery" ? "Delivery" : "Dine-in"),
        table: "-",
        customer: "Rian Pratama",
        items: [...STATE.mobileCart],
        subtotal: subtotal,
        tax: tax,
        total: grandTotal,
        status: "baru",
        isNew: true
      });

      STATE.todayOmzetBraga += subtotal;
      STATE.monthlyRevenue += subtotal;
      STATE.monthlyCogs += cogs;
      STATE.totalCashBank += grandTotal;

      STATE.journals.unshift({
        id: `JRN-${Math.floor(900 + Math.random() * 99)}`,
        time: new Date().toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" }),
        desc: `Pesanan Web Online #${orderId} (QRIS Settlement)`,
        account: `Dr Piutang QRIS Settlement Rp${grandTotal.toLocaleString("id-ID")} / Cr Penjualan Rp${subtotal.toLocaleString("id-ID")} / Cr Hutang Pajak Rp${tax.toLocaleString("id-ID")} | Dr HPP Rp${cogs.toLocaleString("id-ID")} / Cr Persediaan Rp${cogs.toLocaleString("id-ID")}`,
        amount: grandTotal
      });

      showMobilePush("Pembayaran Berhasil ✓", `Pesanan #${orderId} diterima outlet Braga.`);

      STATE.mobileCart = [];
      renderMobileCart();
      renderOrdersKanban();
      renderJournalsTable();
      updateFinancialMetrics();

      document.getElementById("orderSubpageCheckout").classList.remove("active");
      document.getElementById("trackOrderNo").innerText = `#${orderId}`;
      document.getElementById("orderSubpageTracking").classList.add("active");
      updateMobileTrackingStep(1);
    }

    function closeOrderSubpages() {
      document.getElementById("orderSubpageCheckout").classList.remove("active");
      document.getElementById("orderSubpageTracking").classList.remove("active");
    }

    function showMobilePush(title, body) {
      const banner = document.getElementById("orderPushBanner");
      document.getElementById("pushBannerTitle").innerText = title;
      document.getElementById("pushBannerBody").innerText = body;
      banner.classList.add("show");
      setTimeout(() => {
        banner.classList.remove("show");
      }, 5000);
    }

    function updateMobileTrackingStep(stepNum) {
      for (let i = 1; i <= 4; i++) {
        const el = document.getElementById(`step${i}`);
        el.classList.remove("active", "done");
        if (i < stepNum) el.classList.add("done");
        if (i === stepNum) el.classList.add("active");
      }
    }

    /* ------------------------------------------------------------------------
       9. LOKO ASSISTANT (WHATSAPP CHATBOT)
       ------------------------------------------------------------------------ */
    function initWaChat() {
      switchWaPersona("owner");
    }

    function switchWaPersona(persona) {
      STATE.waPersona = persona;
      document.querySelectorAll(".persona-chip").forEach(c => c.classList.remove("active"));
      
      const chipsContainer = document.getElementById("waQuickReplies");
      const stream = document.getElementById("waMessagesStream");
      stream.innerHTML = "";

      if (persona === "owner") {
        document.getElementById("chipPersonaOwner").classList.add("active");
        
        appendWaMessage("in", "Selamat malam, Pak Hendra! Ringkasan performa Loko Coffee hari ini:\n\n• Omzet Braga: Rp5.940.000 (142 tx)\n• Omzet Dago: Rp4.600.000 (114 tx)\n• Total Omzet: Rp10.540.000\n• HPP Bahan: Rp3.689.000 (35%)\n• Estimasi Laba Kotor: Rp6.851.000\n\nKas laci kedua cabang telah terverifikasi klop dengan modal shift. Ada yang ingin dicek lebih lanjut?");

        chipsContainer.innerHTML = `
          <button class="wa-chip-btn" onclick="sendWaPreset('Cek Laba Bersih Bulan Ini')">Laba Bersih Bulan Ini</button>
          <button class="wa-chip-btn" onclick="sendWaPreset('Cek Stok Kritis Outlet')">Cek Stok Kritis</button>
          <button class="wa-chip-btn" onclick="sendWaPreset('Estimasi Setoran Pajak')">Estimasi Pajak</button>
          <button class="wa-chip-btn" onclick="sendWaPreset('Perbandingan Braga vs Dago')">Braga vs Dago</button>
        `;
      } else if (persona === "staff") {
        document.getElementById("chipPersonaStaff").classList.add("active");

        appendWaMessage("in", "Halo Budi (Kasir Braga). Ada yang bisa Loko Assistant bantu untuk operasional kasir atau printer?");

        chipsContainer.innerHTML = `
          <button class="wa-chip-btn" onclick="sendWaPreset('Bagaimana cara void transaksi?')">Cara Void</button>
          <button class="wa-chip-btn" onclick="sendWaPreset('Printer kasir tidak keluar kertas')">Printer Error</button>
          <button class="wa-chip-btn" onclick="sendWaPreset('Cek selisih shift kasir saya')">Cek Selisih Shift</button>
        `;
      } else {
        document.getElementById("chipPersonaCustomer").classList.add("active");

        appendWaMessage("in", "Halo Kak Rian. Selamat datang di Loko Assistant. Ada yang bisa kami bantu seputar pesanan atau poinmu hari ini?");

        chipsContainer.innerHTML = `
          <button class="wa-chip-btn" onclick="sendWaPreset('Cek status pesanan terakhir')">Status Pesanan</button>
          <button class="wa-chip-btn" onclick="sendWaPreset('Berapa poin Loko saya?')">Cek Poin</button>
          <button class="wa-chip-btn" onclick="sendWaPreset('Voucher promo apa yang aktif?')">Promo Aktif</button>
        `;
      }
    }

    function appendWaMessage(type, text) {
      const stream = document.getElementById("waMessagesStream");
      const msg = document.createElement("div");
      msg.className = `wa-msg wa-msg-${type}`;
      msg.innerHTML = `
        ${text.replace(/\n/g, "<br>")}
        <div class="wa-msg-time tabular-nums">${new Date().toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" })}</div>
      `;
      stream.appendChild(msg);
      stream.scrollTop = stream.scrollHeight;
    }

    function sendWaPreset(text) {
      appendWaMessage("out", text);

      setTimeout(() => {
        let reply = "";
        const lower = text.toLowerCase();

        if (lower.includes("laba bersih")) {
          reply = `Laba Bersih bulan berjalan saat ini tercatat Rp65.250.000 (Net Margin 20.7%). Pendapatan Rp315.000.000 dikurangi HPP Rp110.250.000 dan beban operasional Rp139.750.000. Neraca dalam kondisi seimbang.`;
        } else if (lower.includes("stok kritis")) {
          reply = `Alert Bahan Baku: Sirup Karamel sisa 3 botol di Loko Dago. Disarankan order ke Supplier sebelum hari Kamis. Biji Kopi Arabika aman (sisa 18 kg).`;
        } else if (lower.includes("pajak")) {
          reply = `Estimasi kewajiban pajak bulan ini:\n• ${STATE.taxName}: Rp34.650.000\n• PPh Final UMKM (0.5%): Rp1.575.000\nData sudah siap ditarik ke format pelaporan SPT Masa.`;
        } else if (lower.includes("braga vs dago")) {
          reply = `Performa hari ini:\n• Braga: Rp${STATE.todayOmzetBraga.toLocaleString("id-ID")} (58%)\n• Dago: Rp${STATE.todayOmzetDago.toLocaleString("id-ID")} (42%)\nBraga unggul di penjualan Aren Latte, sedangkan Dago unggul di Matcha Latte.`;
        } else if (lower.includes("void")) {
          reply = `Untuk melakukan Void transaksi di POS:\n1. Buka tab Kasir\n2. Klik menu Pengaturan / Histori Transaksi\n3. Pilih transaksi yang dibatalkan\n4. Masukkan 6 digit PIN Manager\nSemua void otomatis tercatat di Audit Log.`;
        } else if (lower.includes("poin")) {
          reply = `Saat ini Kak Rian memiliki 14.500 Loko Points (Tier Gold Bean). Kamu bisa tukarkan 5.000 poin untuk diskon Rp5.000 di pesanan berikutnya.`;
        } else {
          reply = `Loko Assistant menerima permintaanmu: "${text}". Data operasional telah disinkronkan secara real-time dengan server POS dan pembukuan.`;
        }

        appendWaMessage("in", reply);
      }, 500);
    }

    function sendWaCustomMessage() {
      const input = document.getElementById("waCustomInput");
      const text = input.value.trim();
      if (!text) return;
      input.value = "";
      sendWaPreset(text);
    }

    /* ------------------------------------------------------------------------
       10. MODALS & PITCH SCRIPT RUNNER
       ------------------------------------------------------------------------ */
    function closeModal(modalId) {
      document.getElementById(modalId).classList.remove("active");
    }

    function openTableModal() {
      const grid = document.getElementById("tableGrid");
      grid.innerHTML = "";

      MOCK_DATA.tables.forEach(t => {
        const btn = document.createElement("button");
        const isOcc = t.status === "occupied";
        const isBill = t.status === "billing";
        const bg = isOcc ? "var(--danger-bg)" : (isBill ? "var(--warning-bg)" : "var(--success-bg)");
        const border = isOcc ? "var(--danger)" : (isBill ? "var(--warning)" : "var(--success)");
        const label = isOcc ? "Terisi" : (isBill ? "Billing" : "Kosong");

        btn.style.cssText = `background:${bg}; border:1px solid ${border}; border-radius:var(--radius-sm); padding:10px; text-align:center; cursor:pointer;`;
        btn.innerHTML = `
          <div style="font-size:14px; font-weight:700;">Meja ${t.id}</div>
          <div style="font-size:11px; font-weight:600; color:var(--text-secondary); margin-top:2px;">${label}</div>
        `;
        btn.onclick = () => {
          STATE.selectedTable = t.id;
          document.getElementById("labelSelectedTable").innerText = `Meja: ${t.id}`;
          closeModal("tableModal");
        };
        grid.appendChild(btn);
      });

      document.getElementById("tableModal").classList.add("active");
    }

    function openCustomerModal() {
      document.getElementById("customerModal").classList.add("active");
    }

    function selectCustomer(name, pts) {
      STATE.selectedCustomer = { name: name, points: pts };
      document.getElementById("labelSelectedCustomer").innerText = `Pelanggan: ${name}`;
      closeModal("customerModal");
    }

    function openShiftModal() {
      document.getElementById("shiftCashSales").innerText = `Rp${STATE.todayOmzetBraga.toLocaleString("id-ID")}`;
      const exp = 500000 + STATE.todayOmzetBraga - 35000;
      document.getElementById("shiftExpectedCash").innerText = `Rp${exp.toLocaleString("id-ID")}`;
      document.getElementById("shiftActualCash").value = exp;
      calcShiftDiff();
      document.getElementById("shiftModal").classList.add("active");
    }

    function calcShiftDiff() {
      const exp = 500000 + STATE.todayOmzetBraga - 35000;
      const act = parseInt(document.getElementById("shiftActualCash").value || 0, 10);
      const diff = act - exp;

      const statusEl = document.getElementById("shiftDiffStatus");
      if (diff === 0) {
        statusEl.style.background = "var(--success-bg)";
        statusEl.style.color = "var(--success)";
        statusEl.style.borderColor = "var(--success-border)";
        statusEl.innerText = "✓ Selisih: Rp0 (Kas Laci Cocok)";
      } else if (diff > 0) {
        statusEl.style.background = "var(--warning-bg)";
        statusEl.style.color = "var(--warning)";
        statusEl.style.borderColor = "var(--warning-border)";
        statusEl.innerText = `▲ Lebih Fisik: +Rp${diff.toLocaleString("id-ID")}`;
      } else {
        statusEl.style.background = "var(--danger-bg)";
        statusEl.style.color = "var(--danger)";
        statusEl.style.borderColor = "var(--danger-border)";
        statusEl.innerText = `▼ Kurang Fisik: -Rp${Math.abs(diff).toLocaleString("id-ID")}`;
      }
    }

    function openSettingsModal() {
      document.getElementById("settingsModal").classList.add("active");
    }

    function togglePitchGuide() {
      document.getElementById("pitchGuideDrawer").classList.toggle("open");
    }

    function execPitchStep(step) {
      document.querySelectorAll(".guide-step-card").forEach((c, idx) => {
        c.classList.toggle("active", idx === step - 1);
      });

      if (step === 1) {
        switchDevice("order");
        openOrderCheckout();
      } else if (step === 2) {
        switchDevice("pos");
        switchPosTab("pesanan");
      } else if (step === 3) {
        switchDevice("pos");
        switchPosTab("pesanan");
        if (STATE.orders.length > 0) {
          advanceOrderStatus(STATE.orders[0].id, "siap");
        }
      } else if (step === 4) {
        switchDevice("pos");
        switchPosTab("kasir");
        addProductToPosCart(MOCK_DATA.products[4]); // Cappuccino
        addProductToPosCart(MOCK_DATA.products[7]); // Butter Croissant
      } else if (step === 5) {
        switchDevice("pos");
        switchPosTab("accounting");
        switchAccSubtab("journal");
      } else if (step === 6) {
        switchDevice("pos");
        switchPosTab("accounting");
        switchAccSubtab("financials");
      } else if (step === 7) {
        switchDevice("assistant");
        switchWaPersona("owner");
      }
    }

    function resetDemoData() {
      if (confirm("Reset semua data simulasi ke kondisi awal?")) {
        location.reload();
      }
    }
  </script>
</body>
</html>
'@

$finalHtml = $template.Replace('__BASE64_ASSETS_PLACEHOLDER__', $b64Json)
$finalHtml | Set-Content -Encoding UTF8 'd:\job\pos\index.html'

$fileSize = (Get-Item 'd:\job\pos\index.html').Length
Write-Output ("Successfully built index.html. Total size: " + [math]::Round($fileSize/1024, 1) + " KB (" + [math]::Round($fileSize/1MB, 2) + " MB)")
