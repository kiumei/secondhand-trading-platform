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
        when(db.lockGoods("g")).thenReturn(MarketServiceTest.item(1));
        when(db.isFavorite("buyer", "g")).thenReturn(false, true);
        when(db.addFavorite("buyer", "g")).thenReturn(1);
        service.add("buyer", "g"); service.add("buyer", "g");
        verify(db, times(1)).addFavorite("buyer", "g");
        service.remove("buyer", "g");
        verify(db).removeFavorite("buyer", "g");
        service.list("buyer", new PageQuery());
        verify(db).favorites("buyer", 0, 10);
        verify(db).favoriteCount("buyer");
    }
    @Test void cannotFavoriteAnotherUsersPendingGoods() {
        var db = mock(MarketMapper.class);
        when(db.lockGoods("g")).thenReturn(MarketServiceTest.item(0));
        assertThatThrownBy(() -> new FavoriteService(db).add("buyer", "g")).isInstanceOf(BusinessException.class);
        verify(db, never()).addFavorite(any(), any());
    }
}
