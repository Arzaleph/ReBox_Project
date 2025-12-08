# Admin Transaction History - UI Mockup

## Screen Layout

```
┌─────────────────────────────────────────────────────┐
│ ← Riwayat Transaksi        [Export] [Filter]       │ AppBar
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─────────────────────────────────────────────┐   │
│ │ 🔍 Cari transaksi (ID, nama, harga)...  [X] │   │ Search Bar
│ └─────────────────────────────────────────────┘   │
│                                                     │
│ ┌─────────────────────────────────────────────┐   │
│ │  📊 STATISTIK (Gradient Blue Background)     │   │
│ │  ┌──────────┬──────────┬──────────┐         │   │ Stats Card
│ │  │  Total   │ Pending  │Completed │         │   │
│ │  │   125    │    15    │    98    │         │   │
│ │  └──────────┴──────────┴──────────┘         │   │
│ │  ─────────────────────────────────           │   │
│ │  ┌────────────────┬────────────────┐        │   │
│ │  │    Revenue     │   Admin Fee    │        │   │
│ │  │ Rp 15,000,000  │  Rp 1,500,000  │        │   │
│ │  └────────────────┴────────────────┘        │   │
│ └─────────────────────────────────────────────┘   │
│                                                     │
│ ┌─────────────────────────────────────────────┐   │
│ │ [Status: COMPLETED ×] [Cari: "john" ×]      │   │ Active Filters
│ │ 12 hasil                                    │   │
│ └─────────────────────────────────────────────┘   │
│                                                     │
│ ┌─────────────────────────────────────────────┐   │
│ │ [📄] Transaksi #123              ▼          │   │
│ │      [COMPLETED] 15 Des 2024, 14:30         │   │ Transaction Card
│ │      Rp 150,000                             │   │ (Collapsed)
│ └─────────────────────────────────────────────┘   │
│                                                     │
│ ┌─────────────────────────────────────────────┐   │
│ │ [📄] Transaksi #124              ▲          │   │
│ │      [PENDING] 16 Des 2024, 10:15           │   │ Transaction Card
│ │      Rp 250,000                             │   │ (Expanded)
│ │ ─────────────────────────────────────────── │   │
│ │                                             │   │
│ │ 👤 Penjual                                  │   │
│ │    John Doe                                 │   │
│ │    john@example.com                         │   │
│ │    📞 081234567890                          │   │
│ │                                             │   │
│ │ 🚚 Pengepul                                 │   │
│ │    Jane Smith                               │   │
│ │    jane@example.com                         │   │
│ │    📞 081234567891                          │   │
│ │ ─────────────────────────────────────────── │   │
│ │                                             │   │
│ │ Rincian Harga                               │   │
│ │ ┌─────────────────────────────────────────┐ │   │
│ │ │ Total Harga:         Rp 250,000         │ │   │
│ │ │ ─────────────────────────────────────── │ │   │
│ │ │ Admin Fee (10%):     Rp 25,000 ✅       │ │   │
│ │ │ Pengepul Earnings:   Rp 225,000 💰      │ │   │
│ │ └─────────────────────────────────────────┘ │   │
│ │                                             │   │
│ │ Timeline                                    │   │
│ │ 🔵 Dibuat     16 Des 2024, 10:15           │   │
│ │ 🟢 Diterima   16 Des 2024, 11:30           │   │
│ │                                             │   │
│ │ 📝 Catatan                                  │   │
│ │ ┌─────────────────────────────────────────┐ │   │
│ │ │ Pickup at location A, bring bags        │ │   │
│ │ └─────────────────────────────────────────┘ │   │
│ └─────────────────────────────────────────────┘   │
│                                                     │
│ ┌─────────────────────────────────────────────┐   │
│ │ [📄] Transaksi #125              ▼          │   │
│ │      [REJECTED] 17 Des 2024, 09:00          │   │
│ │      Rp 100,000                             │   │
│ └─────────────────────────────────────────────┘   │
│                                                     │
│              [Loading more...]                      │ Pagination Loader
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Color Scheme

### Status Colors
- **Pending:** 🟡 Orange (#FF9800)
- **Accepted:** 🟢 Green (#4CAF50)
- **Completed:** 🟣 Purple (#9C27B0)
- **Rejected:** 🔴 Red (#F44336)
- **Cancelled:** ⚫ Grey (#9E9E9E)

### UI Elements
- **Primary Color:** Blue (#2196F3)
- **Stats Card:** Gradient Blue
- **Search Bar:** Light Grey Background (#F5F5F5)
- **Active Filters:** Primary Color Chips
- **Admin Fee:** Green (#4CAF50)
- **Pengepul Earnings:** Blue (#2196F3)
- **Notes Box:** Amber Background (#FFF8E1) with Amber Border

## Interactions

### 1. Search
```
User types "john" → Updates _searchQuery
                  → Filters transactions by ID/name/price
                  → Updates list in real-time
```

### 2. Status Filter
```
User clicks [Filter] → Shows popup menu
                     → Selects "Completed"
                     → Updates _filterStatus
                     → Shows chip "Status: COMPLETED [×]"
                     → Filters list
```

### 3. Clear Filters
```
User clicks [×] on chip → Removes filter
                        → Updates list
                        → Hides chip if no filters active
```

### 4. Expand Transaction
```
User taps transaction card → ExpansionTile expands
                           → Shows full details
                           → Icon changes ▼ → ▲
```

### 5. Export
```
User clicks [Export] → Generates CSV data
                     → Shows dialog with selectable text
                     → User can copy data
```

### 6. Pagination
```
User scrolls to 80% → Detects via ScrollController
                    → Calls _loadMoreTransactions()
                    → Shows loading indicator
                    → Appends new transactions
                    → Updates _currentPage
```

### 7. Pull-to-Refresh
```
User pulls down → Shows refresh indicator
                → Calls _loadData()
                → Clears current data
                → Fetches page 1
                → Resets pagination
                → Updates UI
```

## Data Flow

```
                    ┌─────────────────┐
                    │  User Actions   │
                    └────────┬────────┘
                             │
                ┌────────────┼────────────┐
                │            │            │
          [Search]    [Filter]      [Scroll]
                │            │            │
                ▼            ▼            ▼
         _searchQuery  _filterStatus  Pagination
                │            │            │
                └────────────┼────────────┘
                             │
                             ▼
                  _filteredTransactions
                    (computed getter)
                             │
                ┌────────────┼────────────┐
                │            │            │
         Applies Search  Applies    Returns
         Filter          Status     Filtered
                │        Filter     List
                │            │            │
                └────────────┼────────────┘
                             │
                             ▼
                      ListView.builder
                             │
                             ▼
                     Transaction Cards
```

## Responsive Design

- **Search Bar:** Full width with padding
- **Stats Card:** Expands to container width
- **Transaction Cards:** Full width with 12px bottom margin
- **Expansion Details:** Proper padding (16px)
- **Scrollable:** Entire list scrollable
- **Touch Targets:** All buttons/chips have adequate size

## Accessibility

- ✅ Readable font sizes (10-16pt)
- ✅ High contrast colors
- ✅ Clear icons with semantic meaning
- ✅ Descriptive labels
- ✅ Touch-friendly spacing
- ✅ Loading states visible
- ✅ Error messages clear

## Edge Cases Handled

1. **No Transactions:** Shows empty state with icon
2. **No Search Results:** Shows empty list
3. **Last Page:** Stops pagination when reached
4. **Network Error:** Shows SnackBar with error
5. **Empty Notes:** Hides notes section
6. **Missing Dates:** Shows "-" for null dates
7. **Null User Data:** Shows "-" for missing info

---

**Design Philosophy:**
- **Clean & Modern:** Material Design principles
- **Information Hierarchy:** Important info prominent
- **Progressive Disclosure:** Details on expand
- **Fast Interactions:** Real-time search, smooth scroll
- **User Feedback:** Loading states, error messages
- **Data-Dense:** Maximum info in minimum space
