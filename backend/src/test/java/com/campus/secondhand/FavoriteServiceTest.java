package com.campus.secondhand;

import com.campus.secondhand.common.*;
import com.campus.secondhand.market.*;
import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

class FavoriteServiceTest {
    @Test void repeatsDoNotInsertAndRemovalAlwaysScopesOwner() {
        var db = mock(MarketMapper.class);
        var service = new FavoriteService(db);
        when(db.goods("g")).thenReturn(MarketServiceTest.item(1));
        when(db.favoriteExists("buyer", "g")).thenReturn(false, true);
        when(db.insertFavorite("buyer", "g")).thenReturn(1);
        service.add("buyer", "g");
        assertThatThrownBy(() -> service.add("buyer", "g")).isInstanceOf(BusinessException.class);
        verify(db, times(1)).insertFavorite("buyer", "g");
        when(db.deleteFavorite("buyer", "g")).thenReturn(1);
        service.remove("buyer", "g");
        verify(db).deleteFavorite("buyer", "g");
        service.list("buyer", new PageQuery());
        verify(db).favoriteGoods("buyer", 0, 10);
        verify(db).favoriteCount("buyer");
    }
    @Test void cannotFavoriteAnotherUsersPendingGoods() {
        var db = mock(MarketMapper.class);
        when(db.goods("g")).thenReturn(MarketServiceTest.item(0));
        assertThatThrownBy(() -> new FavoriteService(db).add("buyer", "g")).isInstanceOf(BusinessException.class);
        verify(db, never()).insertFavorite(any(), any());
    }
}
